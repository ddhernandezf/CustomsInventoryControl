CREATE PROCEDURE [dbo].[spg_Report_FrozenList]
	@IdCustomer	INT,
	@IdAccount	INT,
	@StartDate	DATE,
	@EndDate	DATE
AS
	DECLARE	@UseDate	BIT;

	SELECT @UseDate = CASE WHEN @StartDate IS NOT NULL AND @EndDate IS NOT NULL
					THEN CONVERT(BIT, 1)
					ELSE	CONVERT(BIT, 0)
			END;
			
	
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

	DECLARE @FileHeaderTemp TABLE(
		[Id]				INT NOT NULL,
		[IdCustomer]		INT NOT NULL,
		[IdFileInfoConfig]	INT NOT NULL,
		[IdDocument]		VARCHAR(100) NULL,
		[AuthorizationDate] DATETIME NULL,
		[ExpantionDate]		DATETIME NULL,
		[ExpirationDate]	DATETIME NULL,
		[DocumentDate]		DATETIME NULL,
		[ArrivalDate]		DATETIME NULL,
		[ExchangeRate]		DECIMAL(18,6) NULL,
		[Insurance]			DECIMAL(18,6) NULL,
		[Cargo]				DECIMAL(18,6) NULL,
		[IdCustom]			INT NULL,
		[IdCountry]			INT NULL,
		[IdWarranty]		INT NULL,
		[IdCellar]			INT NULL,
		[IdState]			INT NULL,
		[IdCurrency]		INT NULL,
		[IdResolution]		INT NULL,
		[IdAccount]			INT NULL,
		[Reviewed]			BIT NOT NULL DEFAULT 0,
		[CIFTotal]			DECIMAL(18,6) NULL,
		[LinesTotal]		INT NULL,
		[RegisterDate]		DATETIME NOT NULL,
		[RegisterUser]		VARCHAR(60) NOT NULL,
		[CreateDate]		DATETIME NOT NULL,
		[UpdateDate]		DATETIME NULL
	)
	DECLARE @ItemInventoryTemp TABLE (
		[IdCustomer]		INT NOT NULL,
		[IdAccount]			INT NOT NULL,
		[IdFileHeader]		INT NOT NULL,
		[IdFileDetail]		INT NOT NULL,
		[IdItem]			INT NOT NULL,
		[Original]			DECIMAL(18,6) NOT NULL,
		[Stock]				DECIMAL(18,6) NOT NULL,
		[CIFcost]			DECIMAL(18,6) NOT NULL,
		[FOcost]			DECIMAL(18,6) NULL,
		[CustomDuties]		DECIMAL(18,6) NULL,
		[Iva]				DECIMAL(18,6) NOT NULL,
		[TransactionDate]	DATETIME NOT NULL,
		[IdState]			INT NOT NULL,
		[Freeze]			DECIMAL(18,6) NULL
	)
	DECLARE @FileDetailTemp TABLE (
		[Id]				INT NOT NULL,
		[IdFileHeader]		INT NOT NULL,
		[IdState]			INT NOT NULL,
		[TransactionLine]	INT NULL,
		[IdItem]			INT NOT NULL,
		[ItemQuantity]		DECIMAL(18, 6) NULL,
		[CIFCotQuetzal]		DECIMAL(18,6) NULL,
		[FOCostQuetzal]		DECIMAL(18,6) NULL,
		[CIFCotDollar]		DECIMAL(18,6) NULL,
		[FOCostDollar]		DECIMAL(18,6) NULL,
		[CustomDuties]		DECIMAL(18,6) NULL,
		[Iva]				DECIMAL(18,6) NULL,
		[TaxableBase]		DECIMAL(18,6) NULL,
		[TaxRate]			DECIMAL(18,6) NULL,
		[NetWeight]			DECIMAL(18,6) NULL,
		[GrossWeight]		DECIMAL(18,6) NULL,
		[RegisterDate]		DATETIME NULL,
		[RegisterUser]		VARCHAR(60) NOT NULL,
		[Freeze]			DECIMAL(18,6) NULL,
		[Pcnt]				DECIMAL(18,6) NULL,
		[IsFrozen]			BIT
	)
	DECLARE @FileAttachedTemp TABLE (
		[Id]				INT,
		[AttachedNumber]	VARCHAR(100) NULL,
		[CustomerName]		VARCHAR(400) NULL,
		[Nit]				VARCHAR(15) NULL,
		[Address]			VARCHAR(250) NULL,
		[PhoneNumber]		VARCHAR(15) NULL	
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

	IF(@UseDate = 0)
		BEGIN
			INSERT INTO @ItemInventoryTemp(IdCustomer, IdAccount, IdFileHeader, IdFileDetail, IdItem, Original, Stock,
									CIFcost, FOcost, CustomDuties, Iva, TransactionDate, IdState, Freeze)
			SELECT	ii.IdCustomer, ii.IdAccount, ii.IdFileHeader, ii.IdFileDetail, ii.IdItem, ii.Quantity, ii.Stock,
					ii.CIFcost, ii.FOcost, ii.CustomDuties, ii.Iva, ii.TransactionDate, ii.IdState, ii.Freeze
			  FROM	ItemInventory ii INNER JOIN FileHeader fh ON fh.Id = ii.IdFileHeader
			 WHERE	ii.IdCustomer = @IdCustomer
			   AND	ii.IdAccount = @IdAccount
			   AND	ii.Freeze IS NOT NULL
		END
	ELSE
		BEGIN
			INSERT INTO @ItemInventoryTemp(IdCustomer, IdAccount, IdFileHeader, IdFileDetail, IdItem, Original, Stock,
									CIFcost, FOcost, CustomDuties, Iva, TransactionDate, IdState, Freeze)
			SELECT	ii.IdCustomer, ii.IdAccount, ii.IdFileHeader, ii.IdFileDetail, ii.IdItem, ii.Quantity, ii.Stock,
					ii.CIFcost, ii.FOcost, ii.CustomDuties, ii.Iva, ii.TransactionDate, ii.IdState, ii.Freeze
			  FROM	ItemInventory ii INNER JOIN FileHeader fh ON fh.Id = ii.IdFileHeader
			 WHERE	ii.IdCustomer = @IdCustomer
			   AND	ii.IdAccount = @IdAccount
			   AND	ii.Freeze IS NOT NULL
			   AND	CONVERT(DATE, fh.AuthorizationDate) <= @EndDate
			   AND	CONVERT(DATE, fh.AuthorizationDate) >= @StartDate
		END

	INSERT INTO @FileDetailTemp(Id, IdFileHeader, IdState, TransactionLine, IdItem, ItemQuantity, CIFCotQuetzal, FOCostQuetzal, CIFCotDollar,
								FOCostDollar, CustomDuties, Iva, TaxableBase, TaxRate, NetWeight, GrossWeight, RegisterDate, RegisterUser,
								Freeze, Pcnt, IsFrozen)
	SELECT	fd.Id, fd.IdFileHeader, fd.IdState, fd.TransactionLine, fd.IdItem, fd.ItemQuantity, fd.CIFCotQuetzal, fd.FOCostQuetzal, fd.CIFCotDollar,
			fd.FOCostDollar, fd.CustomDuties, fd.Iva, fd.TaxableBase, fd.TaxRate, fd.NetWeight, fd.GrossWeight, fd.RegisterDate, fd.RegisterUser,
			ii.Freeze, (ii.Freeze / fd.ItemQuantity) Pcnt, 
			CASE WHEN ii.Freeze IS NULL 
				THEN	CONVERT(BIT, 0)
				ELSE	CONVERT(BIT, 1) 
			END [IsFrozen]
	  FROM	FileDetail fd INNER JOIN @ItemInventoryTemp ii ON fd.Id = ii.IdFileDetail

	INSERT INTO @FileHeaderTemp
	SELECT	*
	  FROM	[FileHeader]
	 WHERE	Id IN (	SELECT	DISTINCT IdFileHeader	
					  FROM	@FileDetailTemp)

	INSERT INTO @FileAttachedTemp(Id, AttachedNumber, CustomerName, Nit, [Address], PhoneNumber)
	SELECT	FA.Id, fa.AttachedNumber,
			CASE WHEN p.IsEnterprise = 1
				THEN p.EnterpriseName
				ELSE
					CASE WHEN p.LastName IS NULL	
						THEN p.FirstName
						ELSE CONCAT(p.FirstName, ' ', p.LastName)
					END
			END[SupplierName], p.Nit,
			(	SELECT	TOP 1 a.[Address]
				  FROM	[Address] a INNER JOIN [AddressType] att ON a.IdAddressType = att.Id
				 WHERE	a.IdPerson = s.IdPerson
				   AND	att.[Description] in ('Negocio', 'Trabajo', 'Oficina'))[Address],
			(	SELECT	TOP 1 pp.Number
				  FROM	[Phone] pp INNER JOIN [PhoneType] pt ON pp.IdPhoneType = pt.Id
				 WHERE	pp.IdPerson = s.IdPerson
				   AND	pt.[Description] in ('Trabajo', 'Oficina'))[PhoneNumber]
	  FROM	FileAttached fa INNER JOIN @FileHeaderTemp fh ON fh.Id = fa.IdFileHeader
							INNER JOIN Supplier s ON s.IdPerson = fa.IdSupplier
							INNER JOIN Person p ON p.Id = s.IdPerson

	SELECT	fh.Id[Id_Cabecera_Importacion], fh.IdDocument[Poliza_Importacion], fh.AuthorizationDate[Fecha_Autorizacion], 
			fh.ExpirationDate[Fecha_Vencimiento], fh.ExchangeRate[Tipo_Cambio], c.Code[Id_Aduana], fh.RegisterDate[Fecha_Sistema],
			fh.Insurance[Seguro], fh.Cargo[Flete],
			(	SELECT	TOP 1 AttachedNumber
					FROM	@FileAttachedTemp
					WHERE	IdFileHeader = fh.Id
					ORDER BY Id ASC)[Numero_Factura],
			CASE WHEN fh.IdResolution IS NULL THEN 0 ELSE fh.IdResolution END [Numero_Resolucion],
			CASE WHEN	@IdAccount = 2 
				THEN NULL
				ELSE w.[Name]
			END[Des_Garantia],
			c.[Name][Des_Aduana], ct.[Name][Des_Pais],fd.Id[Id_Detalle_Importacion], fd.TransactionLine[Linea_Importacion], fd.ItemQuantity[Cantidad], 
			ISNULL(fd.CIFCotQuetzal, 0)[Costo_Cif_Quetzales], ISNULL(fd.FOCostQuetzal, 0)[Costo_Fob_Quetzales], ISNULL(fd.CustomDuties, 0)[Derechos_Suspenso], 
			ISNULL(fd.Iva, 0)[Iva_Suspenso],
			ctt.IdPerson[Id_Cliente], ctt.CustomerName[Nombre_Cliente], ctt.Nit[Nit_Cliente], ctt.[Address][Direccion_Cliente], 
			ctt.PhoneNumber[Telefono_Cliente], ctt.PersonCode[Codigo_Cliente], ctt.ImporterCode[Codigo_Importador_Exportador], 
			ctt.ResolutionRate[Resolucion_Calificacion], ctt.ResolutionStartDate[Fecha_Resolucion], 
			ctt.ResolutionEndDate[C_Vencimiento],
			(	SELECT	TOP 1 fat.CustomerName
					FROM	@FileAttachedTemp fat
					WHERE	IdFileHeader = fh.Id
					ORDER BY Id ASC)[Nombre_Proveedor],
			(	SELECT	TOP 1 fat.Nit
					FROM	@FileAttachedTemp fat
					WHERE	IdFileHeader = fh.Id
					ORDER BY Id ASC)[Nit_Proveedor],
			(	SELECT	TOP 1 fat.[Address]
					FROM	@FileAttachedTemp fat
					WHERE	IdFileHeader = fh.Id
					ORDER BY Id ASC)[Direccion_Proveedor],
			(	SELECT	TOP 1 fat.PhoneNumber
					FROM	@FileAttachedTemp fat
					WHERE	IdFileHeader = fh.Id
					ORDER BY Id ASC)[Telefono_Proveedor],
			i.[Name][Des_Materia_Prima], i.Code[Codigo_Materia_Prima], a.AccountingItem[Partida_Materia], u.[Name][Des_Unidad_Medida], 
			r.[Name][Des_Resolucion], fd.IsFrozen,
			fd.Freeze FrozenQuantity,
			fd.CIFCotQuetzal * fd.Pcnt Cif_Frozen,
			fd.CIFCotDollar * fd.Pcnt CifD_Frozen,
			fd.FOCostQuetzal * fd.Pcnt Fob_Frozen,
			fd.FOCostDollar * fd.Pcnt FobD_Frozen,
			fd.Iva * fd.Pcnt Iva_Frozen,
			fd.CustomDuties * fd.Pcnt DAI_Frozen
		FROM	@FileHeaderTemp fh LEFT JOIN Warranty w ON w.Id = fh.IdWarranty
								LEFT JOIN Customs c ON c.Id = fh.IdCustom
								LEFT JOIN Country ct ON ct.Id = fh.IdCountry
								INNER JOIN @FileDetailTemp fd ON fd.IdFileHeader = fh.Id
								INNER JOIN @CustomerTemp ctt ON ctt.IdPerson = fh.IdCustomer
								INNER JOIN Item i ON i.Id = fd.IdItem
								INNER JOIN UnitMeasurement u ON u.Id = i.IdUnitMeasurement
								INNER JOIN AccountingItem a ON a.Id = i.IdAccountingItem
								INNER JOIN Resolution r ON r.Id = i.IdResolution
