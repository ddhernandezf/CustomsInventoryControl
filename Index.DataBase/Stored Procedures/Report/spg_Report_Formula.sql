CREATE PROCEDURE [dbo].[spg_Report_Formula]
	@IdCustomer	INT,
	@IdAccount	INT,
	@IdMainItem	INT
AS
	DECLARE @CustomerTemp TABLE(
		[IdPerson]				INT NOT NULL,
		[CustomerName]			VARCHAR(400) NULL,
		[Nit]					VARCHAR(15) NULL,
		[Address]				VARCHAR(250) NULL,
		[PhoneNumber]			VARCHAR(15) NULL,
		[PersonCode]			NVARCHAR(100) NULL,
		[ImporterCode]			NVARCHAR(100) NULL,
		[ResolutionRate]		NVARCHAR(100) NULL,
		[ResolutionStartDate]	DATE NULL,
		[ResolutionEndDate]		DATE NULL
	)
	DECLARE @MainItemTemp TABLE(
		[IdCustomer]			INT NOT NULL,
		[IdMainItem]			INT NOT NULL,
		[ItemName]				VARCHAR(200) NULL,
		[ItemDescription]		VARCHAR(200) NULL,
		[ItemCode]				VARCHAR(50) NULL,
		[ItemBarCode]			VARCHAR(100) NULL,
		[AccountingItem]		VARCHAR(45) NULL,
		[UM_Name]				VARCHAR(150) NULL
	)
	DECLARE @DetailItemTemp TABLE(
		[IdDetailItem]			INT NOT NULL,
		[ItemName]				VARCHAR(200) NULL,
		[ItemDescription]		VARCHAR(200) NULL,
		[ItemCode]				VARCHAR(50) NULL,
		[ItemBarCode]			VARCHAR(100) NULL,
		[AccountingItem]		VARCHAR(45) NULL,
		[UM_Name]				VARCHAR(150) NULL
	)

	INSERT INTO @CustomerTemp(IdPerson, CustomerName, Nit, PersonCode, [Address], PhoneNumber, ImporterCode, ResolutionRate,
								ResolutionStartDate, ResolutionEndDate)
	SELECT	c.IdPerson, 
		CASE WHEN p.IsEnterprise = 1
			THEN p.EnterpriseName
			ELSE
				CASE WHEN p.LastName IS NULL	
					THEN p.FirstName
					ELSE CONCAT(p.FirstName, ' ', p.LastName)
				END
		END[CustomerName],
		p.Nit, c.PersonCode, 
		(	SELECT	TOP 1 a.[Address]
			  FROM	[Address] a INNER JOIN [AddressType] att ON a.IdAddressType = att.Id
			 WHERE	a.IdPerson = c.IdPerson
			   AND	att.[Description] in ('Negocio', 'Trabajo', 'Oficina'))[Address],
		(	SELECT	TOP 1 pp.Number
			  FROM	[Phone] pp INNER JOIN [PhoneType] pt ON pp.IdPhoneType = pt.Id
			 WHERE	pp.IdPerson = c.IdPerson
			   AND	pt.[Description] in ('Trabajo', 'Oficina'))[PhoneNumber],
		c.ImporterCode, ca.ResolutionRate, ca.ResolutionStartDate, ca.ResolutionEndDate
	  FROM	Customer c INNER JOIN Person p ON p.Id = c.IdPerson
					   INNER JOIN CustomerAccount ca ON ca.IdCustomer = c.IdPerson
													 AND ca.IdAccount = @IdAccount
	 WHERE	c.IdPerson = @IdCustomer

	 INSERT INTO @MainItemTemp (IdCustomer, IdMainItem, ItemName, ItemDescription, ItemCode, ItemBarCode, AccountingItem, UM_Name)
	 SELECT it.IdCustomer, it.Id, it.Name, it.[Description], it.Code, it.Barcode, ai.AccountingItem, um.Name
	 FROM [Item] it LEFT OUTER JOIN [ResolutionAccountingItem] rai ON rai.IdAccountingItem = it.IdAccountingItem
																AND rai.IdResolution = it.IdResolution
					LEFT OUTER JOIN [AccountingItem] ai ON ai.Id = rai.IdAccountingItem
					INNER JOIN [UnitMeasurement] um ON um.Id = it.IdUnitMeasurement
	 WHERE it.IsProduct = 1
		AND it.IdCustomer = @IdCustomer
		AND	it.IdAccount = @IdAccount

	 INSERT INTO @DetailItemTemp (IdDetailItem, ItemName, ItemDescription, ItemCode, ItemBarCode, AccountingItem, UM_Name)
	 SELECT it.Id, it.Name, it.[Description], it.Code, it.Barcode, ai.AccountingItem, um.Name
	 FROM [Item] it LEFT OUTER JOIN [ResolutionAccountingItem] rai ON rai.IdAccountingItem = it.IdAccountingItem
																AND rai.IdResolution = it.IdResolution
					LEFT OUTER JOIN [AccountingItem] ai ON ai.Id = rai.IdAccountingItem
					INNER JOIN [UnitMeasurement] um ON um.Id = it.IdUnitMeasurement
	 WHERE it.IsProduct = 0
		AND it.IdCustomer = @IdCustomer
		AND	it.IdAccount = @IdAccount

	IF ISNULL(@IdMainItem,0) = 0
		Begin
			SELECT fo.Id Id_Formula,
					fo.IdMainItem Id_Producto,
					fo.IdDetailItem Id_Materia_Prima,
					fo.Quantity Cantidad,
					fo.Decrease Cantidad_Merma,
					ip.ItemName Des_Producto,
					ip.ItemCode Codigo_Producto,
					ip.AccountingItem Partida_Producto,
					im.ItemName Des_Materia,
					im.ItemCode Codigo_Materia,
					im.AccountingItem Partida_Materia,
					ct.CustomerName Nombre_Cliente,
					ct.Nit Nit_Cliente,
					ct.Address Direccion,
					ct.PhoneNumber Telefono,
					ct.PersonCode Codigo_Cliente,
					ip.UM_Name Des_Unidad_Producto,
					im.UM_Name Des_Unidad_Materia
				FROM Formula fo INNER JOIN @MainItemTemp ip ON ip.IdMainItem = fo.IdMainItem
								INNER JOIN @DetailItemTemp im ON im.IdDetailItem = fo.IdDetailItem
								INNER JOIN @CustomerTemp ct ON ct.IdPerson = ip.IdCustomer
		end
	ELSE
		Begin
			SELECT fo.Id Id_Formula,
					fo.IdMainItem Id_Producto,
					fo.IdDetailItem Id_Materia_Prima,
					fo.Quantity Cantidad,
					fo.Decrease Cantidad_Merma,
					ip.ItemName Des_Producto,
					ip.ItemCode Codigo_Producto,
					ip.AccountingItem Partida_Producto,
					im.ItemName Des_Materia,
					im.ItemCode Codigo_Materia,
					im.AccountingItem Partida_Materia,
					ct.CustomerName Nombre_Cliente,
					ct.Nit Nit_Cliente,
					ct.Address Direccion,
					ct.PhoneNumber Telefono,
					ct.PersonCode Codigo_Cliente,
					ip.UM_Name Des_Unidad_Producto,
					im.UM_Name Des_Unidad_Materia
				FROM Formula fo INNER JOIN @MainItemTemp ip ON ip.IdMainItem = fo.IdMainItem
								INNER JOIN @DetailItemTemp im ON im.IdDetailItem = fo.IdDetailItem
								INNER JOIN @CustomerTemp ct ON ct.IdPerson = ip.IdCustomer
				WHERE fo.IdMainItem = @IdMainItem
		End	