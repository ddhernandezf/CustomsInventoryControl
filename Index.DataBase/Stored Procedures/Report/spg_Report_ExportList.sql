CREATE PROCEDURE [dbo].[spg_Report_ExportList]
	@IdCustomer	INT,
	@IdAccount	INT,
	@StartDate	DATE,
	@EndDate	DATE,
	@TransFlag	BIT
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
	DECLARE @FileHeaderExportsTemp TABLE (
		[Id] INT NOT NULL,
		[IdCustomer] INT NOT NULL,
		[IdFileInfoConfig] INT NOT NULL,
		[IdDocument] VARCHAR(100) NULL,
		[AuthorizationDate] DATETIME NULL,
		[ExpantionDate] DATETIME NULL,
		[ExpirationDate] DATETIME NULL,
		[DocumentDate] DATETIME NULL,
		[ArrivalDate] DATETIME NULL,
		[ExchangeRate] DECIMAL(18,6) NULL,
		[Insurance] DECIMAL(18,6) NULL,
		[Cargo] DECIMAL(18,6) NULL,
		[IdCustom] INT NULL,
		[IdCountry]INT NULL,
		[IdWarranty]INT NULL,
		[IdCellar]INT NULL,
		[IdState] INT NULL,
		[IdCurrency] INT NULL,
		[IdResolution] INT NULL,
		[IdAccount] INT NULL,
		[Reviewed] BIT NOT NULL DEFAULT 0,
		[CIFTotal] DECIMAL(18,6) NULL,
		[LinesTotal] INT NULL,
		[RegisterDate] DATETIME NOT NULL,
		[RegisterUser] VARCHAR(60) NOT NULL,
		[CreateDate] DATETIME NOT NULL,
		[UpdateDate] DATETIME NULL,
		[Des_Documento] VARCHAR(60) NULL
	)
	--DECLARE @FileAttachedExportTemp TABLE (
	--	[Id]				INT,
	--	[AttachedNumber]	VARCHAR(100) NULL,
	--	[AttachedDate]		DATETIME NULL,
	--	[CustomerName]		VARCHAR(400) NULL,
	--	[Nit]				VARCHAR(15) NULL,
	--	[Address]			VARCHAR(250) NULL,
	--	[PhoneNumber]		VARCHAR(15) NULL,
	--	[IdFileHeader]		INT NULL
	--)
	DECLARE @FileDetailExportsTemp TABLE (
		[Id] INT NOT NULL,
		[IdFileHeader] INT NOT NULL,
		[IdState] INT NOT NULL,
		[TransactionLine] INT NULL,
		[IdItem] INT NOT NULL,
		[ItemQuantity] DECIMAL(18, 6) NULL,
		[CIFCotQuetzal] DECIMAL(18,6) NULL,
		[FOCostQuetzal] DECIMAL(18,6) NULL,
		[CIFCotDollar] DECIMAL(18,6) NULL,
		[FOCostDollar] DECIMAL(18,6) NULL,
		[CustomDuties] DECIMAL(18,6) NULL,
		[Iva] DECIMAL(18,6) NULL,
		[TaxableBase] DECIMAL(18,6) NULL,
		[TaxRate] DECIMAL(18,6) NULL,
		[NetWeight] DECIMAL(18,6) NULL,
		[GrossWeight] DECIMAL(18,6) NULL,
		[RegisterDate] DATETIME NULL,
		[RegisterUser] VARCHAR(60) NOT NULL
	)
	DECLARE @ItemProductTemp TABLE (
		[Id] INT NOT NULL,
		[IdAccount] INT NULL,
		[IdCustomer] INT NOT NULL,
		[IdResolution] INT NOT NULL,
		[IdAccountingItem] INT NOT NULL,
		[IdUnitMeasurement] INT NOT NULL,
		[Code] NVARCHAR(50) NOT NULL,
		[Name] VARCHAR(200) NOT NULL,
		[Description] VARCHAR(1000) NULL,
		[Barcode] NVARCHAR(100) NULL,
		[IsProduct] BIT NOT NULL,
		[RegisterDate] DATETIME NOT NULL,
		[RegisterUser] VARCHAR(60) NOT NULL,
		[AccountingItem] VARCHAR(50) NULL
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

	INSERT INTO @FileHeaderExportsTemp
	select distinct fh.*, fi.[Name] + ' ' + fit.[Name] Des_Documento
	from FileHeader fh INNER JOIN FileInfoConfig fic ON fic.Id = fh.IdFileInfoConfig
						INNER JOIN FileInfoType fit ON fit.Id = fic.IdFileType
						INNER JOIN FileInfo fi ON fi.Id = fic.IdFileInfo
	where fh.IdCustomer = @IdCustomer
		and fh.IdAccount = @IdAccount
		and (CONVERT(DATE,fh.CreateDate) BETWEEN @StartDate AND @EndDate)
		and lower(fit.Name) like '%export%'
		and fic.IsSubstract = 1

	--INSERT INTO @FileAttachedExportTemp(Id, AttachedNumber, AttachedDate, CustomerName, Nit, [Address], PhoneNumber, IdFileHeader)
	--SELECT	FA.Id, fa.AttachedNumber,
	--		fa.AttachedDate,
	--		CASE WHEN p.IsEnterprise = 1
	--			THEN p.EnterpriseName
	--			ELSE
	--				CASE WHEN p.LastName IS NULL	
	--					THEN p.FirstName
	--					ELSE CONCAT(p.FirstName, ' ', p.LastName)
	--				END
	--		END[SupplierName], p.Nit,
	--		(	SELECT	TOP 1 a.[Address]
	--			  FROM	[Address] a INNER JOIN [AddressType] att ON a.IdAddressType = att.Id
	--			 WHERE	a.IdPerson = s.IdPerson
	--			   AND	att.[Description] in ('Negocio', 'Trabajo', 'Oficina'))[Address],
	--		(	SELECT	TOP 1 pp.Number
	--			  FROM	[Phone] pp INNER JOIN [PhoneType] pt ON pp.IdPhoneType = pt.Id
	--			 WHERE	pp.IdPerson = s.IdPerson
	--			   AND	pt.[Description] in ('Trabajo', 'Oficina'))[PhoneNumber], fh.id
	--  FROM	FileAttached fa INNER JOIN @FileHeaderExportsTemp fh ON fh.Id = fa.IdFileHeader
	--						INNER JOIN Supplier s ON s.IdPerson = fa.IdSupplier
	--						INNER JOIN Person p ON p.Id = s.IdPerson

	INSERT INTO @FileDetailExportsTemp
	SELECT	DISTINCT fde.*
	  FROM	[FileDetail] fde INNER JOIN @FileHeaderExportsTemp fhe ON fde.IdFileHeader = fhe.Id

	INSERT INTO @ItemProductTemp(Id, IdAccount, IdCustomer, IdResolution, IdAccountingItem, IdUnitMeasurement, Code,
									[Name], [Description], Barcode, IsProduct, RegisterDate, RegisterUser, AccountingItem)
	SELECT	i.Id, i.IdAccount, i.IdCustomer, i.IdResolution, i.IdAccountingItem, i.IdUnitMeasurement, i.Code,
			i.Name, i.Description, i.Barcode, i.IsProduct, i.RegisterDate, i.RegisterUser, ai.AccountingItem
	  FROM	[Item] i INNER JOIN ResolutionAccountingItem rai ON rai.IdResolution = i.IdResolution
																AND rai.IdAccountingItem = i.IdAccountingItem
						INNER JOIN AccountingItem ai ON ai.Id = rai.IdAccountingItem
	 WHERE	EXISTS (SELECT 1
					FROM @FileDetailExportsTemp fde
					WHERE fde.IdItem = i.Id)
	   AND	i.IsProduct = 1

	SELECT fh.Id Id_Cabecera_Exportacion,
			fh.IdDocument Poliza_Exportacion,
			fh.IdCustomer Id_Cliente,
			ISNULL(fh.DocumentDate, fh.AuthorizationDate) Fecha_Documento,
			fa.AttachedNumber Numero_Factura,
			fa.AttachedDate Fecha_Factura,
			fh.RegisterDate Fecha_Sistema,
			cu.[Name] Nombre_Pais,
			fd.Id Id_Detalle_Exportacion,
			fd.ItemQuantity Cantidad,
			fd.CIFCotQuetzal Costo_Cif_Quetzales,
			fd.FOCostQuetzal Costo_Fob_Quetzales,
			fd.TransactionLine Linea_Exportacion,
			fd.IdItem Id_Producto,
			i.[Name] Des_Producto,
			i.Code Codigo,
			i.AccountingItem Partida_Producto,
			c.CustomerName Nombre_Cliente,
			c.Nit,
			c.[Address] Direccion,
			c.PhoneNumber Telefono,
			fh.Des_Documento
	--SELECT fh.Id
	FROM @FileHeaderExportsTemp fh	INNER JOIN @FileDetailExportsTemp fd ON fd.IdFileHeader = fh.Id
									INNER JOIN @ItemProductTemp i ON i.Id = fd.IdItem
									INNER JOIN @CustomerTemp c ON c.IdPerson = fh.IdCustomer
									LEFT OUTER JOIN FileAttached fa ON fa.IdFileHeader = fh.Id
									LEFT OUTER JOIN Country cu ON cu.Id = fh.IdCountry