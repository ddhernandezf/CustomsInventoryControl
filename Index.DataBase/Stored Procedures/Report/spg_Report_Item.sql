CREATE PROCEDURE [dbo].[spg_Report_Item]
	@IdCustomer	INT,
	@IdAccount	INT,
	@Product	BIT
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
	DECLARE @ProductTemp TABLE(
		[IdCustomer]			INT NOT NULL,
		[IdAccount] 			INT NOT NULL,
		[IdItem]	 			INT NOT NULL,
		[ItemName]				VARCHAR(200) NULL,
		[ItemDescription]		VARCHAR(200) NULL,
		[ItemCode]				VARCHAR(50) NULL,
		[ItemBarCode]			VARCHAR(100) NULL,
		[AccountingItem]		VARCHAR(45) NULL,
		[UM_Name]				VARCHAR(150) NULL,
		[IsProduct]				BIT NULL,
		[Formula]				BIT NULL
	)
	DECLARE @MaterialTemp TABLE(
		[IdCustomer]			INT NOT NULL,
		[IdAccount] 			INT NOT NULL,
		[IdItem] 				INT NOT NULL,
		[ItemName]				VARCHAR(200) NULL,
		[ItemDescription]		VARCHAR(200) NULL,
		[ItemCode]				VARCHAR(50) NULL,
		[ItemBarCode]			VARCHAR(100) NULL,
		[AccountingItem]		VARCHAR(45) NULL,
		[UM_Name]				VARCHAR(150) NULL,
		[IsProduct]				BIT NULL,
		[Formula]				BIT NULL
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

	 INSERT INTO @ProductTemp (IdCustomer, IdAccount, IdItem, ItemName, ItemDescription, ItemCode, ItemBarCode, AccountingItem, UM_Name,
								IsProduct, Formula)
	 SELECT it.IdCustomer, it.IdAccount, it.Id, it.Name, it.[Description], it.Code, it.Barcode, ai.AccountingItem, um.Name, it.IsProduct,
			(SELECT Count(1)
			FROM Formula f
			WHERE f.IdMainItem = it.Id
				and f.Active = 1) Formula
	 FROM [Item] it INNER JOIN [ResolutionAccountingItem] rai ON rai.IdAccountingItem = it.IdAccountingItem
																AND rai.IdResolution = it.IdResolution
					INNER JOIN [AccountingItem] ai ON ai.Id = rai.IdAccountingItem
					INNER JOIN [UnitMeasurement] um ON um.Id = it.IdUnitMeasurement
	 WHERE it.IsProduct = 1
		AND it.IdCustomer = @IdCustomer
		AND	it.IdAccount = @IdAccount

	 INSERT INTO @MaterialTemp (IdCustomer, IdAccount, IdItem, ItemName, ItemDescription, ItemCode, ItemBarCode, AccountingItem, UM_Name,
								IsProduct, Formula)
	 SELECT it.IdCustomer, it.IdAccount, it.Id, it.Name, it.[Description], it.Code, it.Barcode, ai.AccountingItem, um.Name, it.IsProduct,
			(SELECT Count(1)
			FROM Formula f
			WHERE f.IdDetailItem = it.Id
				and f.Active = 1) Formula
	 FROM [Item] it INNER JOIN [ResolutionAccountingItem] rai ON rai.IdAccountingItem = it.IdAccountingItem
																AND rai.IdResolution = it.IdResolution
					INNER JOIN [AccountingItem] ai ON ai.Id = rai.IdAccountingItem
					INNER JOIN [UnitMeasurement] um ON um.Id = it.IdUnitMeasurement
	 WHERE it.IsProduct = 0
		AND it.IdCustomer = @IdCustomer
		AND	it.IdAccount = @IdAccount

	IF (@Product IS NULL)
		Begin
			select it.*,
					cu.CustomerName, cu.ImporterCode, cu.Nit, cu.PersonCode, cu.[Address], cu.PhoneNumber
			from (
					select *
					from @ProductTemp 
					union all
					select * from @MaterialTemp
				) It INNER JOIN @CustomerTemp cu ON cu.IdPerson = it.IdCustomer
		end
	ELSE
		Begin
			IF (@Product = 1)
				Begin
					select it.*,
							cu.CustomerName, cu.ImporterCode, cu.Nit, cu.PersonCode, cu.[Address], cu.PhoneNumber
					from @ProductTemp it INNER JOIN @CustomerTemp cu ON cu.IdPerson = it.IdCustomer
				End
			else
				Begin
					select it.*,
							cu.CustomerName, cu.ImporterCode, cu.Nit, cu.PersonCode, cu.[Address], cu.PhoneNumber
					from @MaterialTemp it INNER JOIN @CustomerTemp cu ON cu.IdPerson = it.IdCustomer
				End
		End
GO