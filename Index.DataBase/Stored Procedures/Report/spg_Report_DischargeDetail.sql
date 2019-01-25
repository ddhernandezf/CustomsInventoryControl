CREATE PROCEDURE [dbo].[spg_Report_DischargeDetail]
	@IdCustomer	INT,
	@IdAccount	INT,
	@StartDate	DATE,
	@EndDate	DATE,
	@TransFlag	BIT,
	@HeaderList	VARCHAR(MAX),
	@DetailList	VARCHAR(MAX)
AS
	DECLARE	@HeaderListTableTemp TABLE(
		[IdFileHeaderTemp]	INT
	)

	DECLARE	@HeaderListTable TABLE(
		[IdFileHeaderTemp]	INT,
		[Type]				VARCHAR(20) NULL
	)

	DECLARE	@DetailListTableTemp TABLE(
		[IdFileDetailTemp]	INT
	)

	DECLARE	@DetailListTable TABLE(
		[IdFileDetailTemp]	INT,
		[Type]				VARCHAR(20) NULL
	)

	DECLARE @FileItemDischargeTemp TABLE (
		[Id] INT NOT NULL,
		[IdFileDetailSubstract] INT NOT NULL,
		[IdFileDetailStock] INT NOT NULL,
		[IdState] INT NOT NULL,
		[Quantity] DECIMAL(18,6) NOT NULL,
		[Decrease] DECIMAL(18,6) NOT NULL,
		[CIFcost] DECIMAL(18,6) NOT NULL,
		[FOcost] DECIMAL(18,6) NULL,
		[CustomDuties] DECIMAL(18,6) NULL,
		[Iva] DECIMAL(18,6) NOT NULL,
		[RegisterDate] DATETIME NOT NULL
	)

	DECLARE @FileItemDischargePastTemp TABLE (
		[IdFileDetailStock] INT NOT NULL,
		[Quantity] DECIMAL(18,6) NOT NULL,
		[Decrease] DECIMAL(18,6) NOT NULL,
		[CIFcost] DECIMAL(18,6) NOT NULL,
		[FOcost] DECIMAL(18,6) NULL,
		[CustomDuties] DECIMAL(18,6) NULL,
		[Iva] DECIMAL(18,6) NOT NULL,
		[RegisterDate] DATETIME NULL
	)

	DECLARE @FileItemDischargeTransmitedTemp TABLE (
		[Id] INT NOT NULL,
		[IdFileDetailSubstract] INT NOT NULL,
		[IdFileDetailStock] INT NOT NULL,
		[IdState] INT NOT NULL,
		[Quantity] DECIMAL(18,6) NOT NULL,
		[Decrease] DECIMAL(18,6) NOT NULL,
		[CIFcost] DECIMAL(18,6) NOT NULL,
		[FOcost] DECIMAL(18,6) NULL,
		[CustomDuties] DECIMAL(18,6) NOT NULL,
		[Iva] DECIMAL(18,6) NOT NULL,
		[RegisterDate] DATETIME NULL
	)

	DECLARE @FileDetailImportsTemp TABLE (
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

	DECLARE @FileHeaderImportsTemp TABLE (
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
		[UpdateDate] DATETIME NULL
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
		[UpdateDate] DATETIME NULL
	)

	DECLARE @ItemRawMaterialTemp TABLE (
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
		[RegisterUser] VARCHAR(60) NOT NULL
	)

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

	DECLARE @FileAttachedImportTemp TABLE (
		[Id]				INT,
		[AttachedNumber]	VARCHAR(100) NULL,
		[CustomerName]		VARCHAR(400) NULL,
		[Nit]				VARCHAR(15) NULL,
		[Address]			VARCHAR(250) NULL,
		[PhoneNumber]		VARCHAR(15) NULL,
		[IdFileHeader]		INT NULL
	)

	DECLARE @FileAttachedExportTemp TABLE (
		[Id]				INT,
		[AttachedNumber]	VARCHAR(100) NULL,
		[CustomerName]		VARCHAR(400) NULL,
		[Nit]				VARCHAR(15) NULL,
		[Address]			VARCHAR(250) NULL,
		[PhoneNumber]		VARCHAR(15) NULL,
		[IdFileHeader]		INT NULL
	)

	DECLARE	@TransmitedInfoTemp	TABLE(
		[IdFileItemDischarge] INT NULL, 
		[TransactionNumber] INT NULL
	)

	IF(ISNULL(@HeaderList, '') <> '')
		BEGIN
			INSERT INTO @HeaderListTableTemp(IdFileHeaderTemp)
			SELECT Item = CONVERT(INT, Item) 
			  FROM	(	SELECT	Item = x.i.value('(./text())[1]', 'varchar(max)')
						  FROM	(	SELECT [XML] = CONVERT(XML, '<i>'
												+ REPLACE(@HeaderList, ',', '</i><i>') + '</i>').query('.')
					  ) AS a CROSS APPLY [XML].nodes('i') AS x(i) 
					  ) AS y
			 WHERE Item IS NOT NULL

			INSERT INTO @HeaderListTable(IdFileHeaderTemp, Type)
			SELECT	hlt.IdFileHeaderTemp, fit.[Name]
			  FROM	@HeaderListTableTemp hlt INNER JOIN FileHeader fh ON fh.Id = hlt.IdFileHeaderTemp
										 INNER JOIN FileInfoConfig fic ON fh.IdFileInfoConfig = fic.Id
										 INNER JOIN FileInfoType fit ON fic.IdFileType = fit.Id
		END

	IF(ISNULL(@DetailList, '') <> '')
		BEGIN
			INSERT INTO @DetailListTableTemp(IdFileDetailTemp)
			SELECT Item = CONVERT(INT, Item) 
			  FROM	(	SELECT	Item = x.i.value('(./text())[1]', 'varchar(max)')
						  FROM	(	SELECT [XML] = CONVERT(XML, '<i>'
												+ REPLACE(@DetailList, ',', '</i><i>') + '</i>').query('.')
					  ) AS a CROSS APPLY [XML].nodes('i') AS x(i) 
					  ) AS y
			 WHERE Item IS NOT NULL

			INSERT INTO @DetailListTable(IdFileDetailTemp, Type)
			SELECT	dlt.IdFileDetailTemp, fit.[Name]
			  FROM	@DetailListTableTemp dlt INNER JOIN FileDetail fd ON fd.Id = dlt.IdFileDetailTemp
										 INNER JOIN FileHeader fh ON fh.Id = fd.IdFileHeader
										 INNER JOIN FileInfoConfig fic ON fh.IdFileInfoConfig = fic.Id
										 INNER JOIN FileInfoType fit ON fic.IdFileType = fit.Id
		END

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

	DECLARE	@DetailListCounter			INT = (SELECT COUNT(*) FROM @DetailListTable),
			@DetailListImportCounter	INT = (SELECT COUNT(*) FROM @DetailListTable WHERE [Type] = 'Importación'),
			@DetailListExportCounter	INT = (SELECT COUNT(*) FROM @DetailListTable WHERE [Type] = 'Exportación');

	INSERT INTO @FileItemDischargePastTemp(	IdFileDetailStock, Quantity, Decrease,
											CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
	SELECT	fid.IdFileDetailStock, SUM(fid.Quantity), SUM(fid.Decrease),
			SUM(fid.CIFcost), SUM(fid.FOcost), SUM(fid.CustomDuties), SUM(fid.Iva), NULL
	  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
									INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
	 WHERE	CONVERT(DATE, fid.RegisterDate) < @StartDate
	   AND	fhi.IdCustomer = @IdCustomer
	   AND	fhi.IdAccount = @IdAccount
	 GROUP	BY fid.IdFileDetailStock;

	IF(@TransFlag IS NULL)
		BEGIN
			IF(@DetailListCounter > 0)
				BEGIN
					IF(@DetailListImportCounter > 0 AND @DetailListExportCounter > 0)
						BEGIN
							INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
							SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
									fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
							  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
															INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
															INNER JOIN @DetailListTable dlti ON fid.IdFileDetailStock = dlti.IdFileDetailTemp
															INNER JOIN @DetailListTable dlte ON fid.IdFileDetailSubstract = dlte.IdFileDetailTemp
							 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
							   AND	fhi.IdCustomer = @IdCustomer
							   AND	fhi.IdAccount = @IdAccount
						END
					ELSE IF(@DetailListImportCounter > 0 AND @DetailListExportCounter <= 0)
						BEGIN
							INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
							SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
									fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
							  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
															INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
															INNER JOIN @DetailListTable dlti ON fid.IdFileDetailStock = dlti.IdFileDetailTemp
							 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
							   AND	fhi.IdCustomer = @IdCustomer
							   AND	fhi.IdAccount = @IdAccount
						END
					ELSE IF(@DetailListImportCounter <= 0 AND @DetailListExportCounter > 0)
						BEGIN
							INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
							SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
									fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
							  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
															INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
															INNER JOIN @DetailListTable dlte ON fid.IdFileDetailSubstract = dlte.IdFileDetailTemp
							 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
							   AND	fhi.IdCustomer = @IdCustomer
							   AND	fhi.IdAccount = @IdAccount
						END
				END
			ELSE
				BEGIN
					INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
														CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
					SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
							fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
					  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
													INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
					   AND	fhi.IdCustomer = @IdCustomer
					   AND	fhi.IdAccount = @IdAccount
				END

			INSERT INTO @FileItemDischargeTransmitedTemp(Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
												CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
			SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, SUM(fid.Quantity), SUM(fid.Decrease),
					SUM(fid.CIFcost), SUM(fid.FOcost), SUM(fid.CustomDuties), SUM(fid.Iva), NULL
				FROM	@FileItemDischargeTemp fid
				WHERE	EXISTS(SELECT 1
									FROM OpaDetailHist odh
									WHERE odh.IdFileItemDischarge = fid.Id)
				GROUP BY fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState;
		END
	ELSE
		BEGIN
			DECLARE	@IdStateTransmited	INT;
			SELECT @IdStateTransmited = Id FROM [State] WHERE [Name] = 'Transmitido';

			IF(@TransFlag = 1)
				BEGIN
					IF(@DetailListCounter > 0)
						BEGIN
							IF(@DetailListImportCounter > 0 AND @DetailListExportCounter > 0)
								BEGIN
									INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																		CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
									SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
											fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
																	INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
																	INNER JOIN @DetailListTable dlti ON fid.IdFileDetailStock = dlti.IdFileDetailTemp
																	INNER JOIN @DetailListTable dlte ON fid.IdFileDetailSubstract = dlte.IdFileDetailTemp
									 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
									   AND	fhi.IdCustomer = @IdCustomer
									   AND	fhi.IdAccount = @IdAccount
									   AND	fid.IdState = @IdStateTransmited
								END
							ELSE IF(@DetailListImportCounter > 0 AND @DetailListExportCounter <= 0)
								BEGIN
									INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																		CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
									SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
											fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
																	INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
																	INNER JOIN @DetailListTable dlti ON fid.IdFileDetailStock = dlti.IdFileDetailTemp
									 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
									   AND	fhi.IdCustomer = @IdCustomer
									   AND	fhi.IdAccount = @IdAccount
									   AND	fid.IdState = @IdStateTransmited
								END
							ELSE IF(@DetailListImportCounter <= 0 AND @DetailListExportCounter > 0)
								BEGIN
									INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																		CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
									SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
											fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
																	INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
																	INNER JOIN @DetailListTable dlte ON fid.IdFileDetailSubstract = dlte.IdFileDetailTemp
									 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
									   AND	fhi.IdCustomer = @IdCustomer
									   AND	fhi.IdAccount = @IdAccount
									   AND	fid.IdState = @IdStateTransmited
								END
						END
					ELSE
						BEGIN
							INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
							SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
									fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
							  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
															INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
							 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
							   AND	fhi.IdCustomer = @IdCustomer
							   AND	fhi.IdAccount = @IdAccount
							   AND	fid.IdState = @IdStateTransmited
						END

					INSERT INTO @FileItemDischargeTransmitedTemp(Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
														CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
					SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, SUM(fid.Quantity), SUM(fid.Decrease),
							SUM(fid.CIFcost), SUM(fid.FOcost), SUM(fid.CustomDuties), SUM(fid.Iva), NULL
					  FROM	@FileItemDischargeTemp fid
					 WHERE	EXISTS(SELECT 1
											FROM OpaDetailHist odh
											WHERE odh.IdFileItemDischarge = fid.Id)
					 GROUP BY fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState;
				END
			ELSE IF(@TransFlag = 0)
				BEGIN
					IF(@DetailListCounter > 0)
						BEGIN
							IF(@DetailListImportCounter > 0 AND @DetailListExportCounter > 0)
								BEGIN
									INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																		CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
									SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
											fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
																	INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
																	INNER JOIN @DetailListTable dlti ON fid.IdFileDetailStock = dlti.IdFileDetailTemp
																	INNER JOIN @DetailListTable dlte ON fid.IdFileDetailSubstract = dlte.IdFileDetailTemp
									 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
									   AND	fhi.IdCustomer = @IdCustomer
									   AND	fhi.IdAccount = @IdAccount
									   AND	fid.IdState <> @IdStateTransmited
								END
							ELSE IF(@DetailListImportCounter > 0 AND @DetailListExportCounter <= 0)
								BEGIN
									INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																		CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
									SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
											fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
																	INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
																	INNER JOIN @DetailListTable dlti ON fid.IdFileDetailStock = dlti.IdFileDetailTemp
									 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
									   AND	fhi.IdCustomer = @IdCustomer
									   AND	fhi.IdAccount = @IdAccount
									   AND	fid.IdState <> @IdStateTransmited
								END
							ELSE IF(@DetailListImportCounter <= 0 AND @DetailListExportCounter > 0)
								BEGIN
									INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																		CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
									SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
											fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
																	INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
																	INNER JOIN @DetailListTable dlte ON fid.IdFileDetailSubstract = dlte.IdFileDetailTemp
									 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
									   AND	fhi.IdCustomer = @IdCustomer
									   AND	fhi.IdAccount = @IdAccount
									   AND	fid.IdState <> @IdStateTransmited
								END
						END
					ELSE
						BEGIN
							INSERT INTO @FileItemDischargeTemp(	Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
																CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
							SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity, fid.Decrease,
									fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva, fid.RegisterDate
							  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
															INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
							 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
							   AND	fhi.IdCustomer = @IdCustomer
							   AND	fhi.IdAccount = @IdAccount
							   AND	fid.IdState <> @IdStateTransmited
						END

					INSERT INTO @FileItemDischargeTransmitedTemp(Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, Decrease,
												CIFcost, FOcost, CustomDuties, Iva, RegisterDate)
					SELECT	fidt.Id, fidt.IdFileDetailSubstract, fidt.IdFileDetailStock, fidt.IdState, SUM(fid.Quantity), 
							SUM(fid.Decrease), SUM(fid.CIFcost),  SUM(fid.FOcost), SUM(fid.CustomDuties), SUM(fid.Iva), NULL
					  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
													INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
													INNER JOIN @FileItemDischargeTemp fidt ON fidt.IdFileDetailStock = fid.IdFileDetailStock
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
					   AND	fhi.IdCustomer = @IdCustomer
					   AND	fhi.IdAccount = @IdAccount
					   AND	fid.IdState = @IdStateTransmited
					 GROUP	BY fidt.Id, fidt.IdFileDetailSubstract, fidt.IdFileDetailStock, fidt.IdState
				END
		END

	INSERT INTO @TransmitedInfoTemp(IdFileItemDischarge, TransactionNumber)
	SELECT odh.IdFileItemDischarge, orh.TransactionNumber
	  from	OpaDetailHist odh INNER JOIN OpaResponseHist orh ON orh.IdOpaDetail = odh.Id
					INNER JOIN @FileItemDischargeTemp fidt ON fidt.Id = odh.IdFileItemDischarge
	  where (orh.TransactionNumber IS NOT NULL
		AND orh.TransactionNumber > 0)

	INSERT INTO @FileDetailImportsTemp
	SELECT	DISTINCT fdi.*
	  FROM	@FileItemDischargeTemp fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
									INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader

	INSERT INTO @FileHeaderImportsTemp
	SELECT	DISTINCT fhi.*
	  FROM	@FileItemDischargeTemp fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
									INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader

	INSERT INTO @FileDetailExportsTemp
	SELECT	DISTINCT fde.*
	  FROM	@FileItemDischargeTemp fid INNER JOIN [FileDetail] fde ON fde.Id = fid.IdFileDetailSubstract
									INNER JOIN [FileHeader] fhe ON fhe.id = fde.IdFileHeader

	INSERT INTO @FileHeaderExportsTemp
	SELECT	DISTINCT fhe.*
	  FROM	@FileItemDischargeTemp fid INNER JOIN [FileDetail] fde ON fde.Id = fid.IdFileDetailSubstract
									INNER JOIN [FileHeader] fhe ON fhe.id = fde.IdFileHeader
									
	INSERT INTO @ItemRawMaterialTemp(Id, IdAccount, IdCustomer, IdResolution, IdAccountingItem, IdUnitMeasurement, Code,
										[Name], [Description], Barcode, IsProduct, RegisterDate, RegisterUser)
	SELECT	i.Id, i.IdAccount, i.IdCustomer, i.IdResolution, i.IdAccountingItem, i.IdUnitMeasurement, i.Code,
			i.Name, i.Description, i.Barcode, i.IsProduct, i.RegisterDate, i.RegisterUser
	  FROM	[Item] i
	 WHERE	i.Id IN (SELECT DISTINCT IdItem FROM @FileDetailImportsTemp)
	   AND	i.IsProduct = 0
	
	INSERT INTO @ItemProductTemp(Id, IdAccount, IdCustomer, IdResolution, IdAccountingItem, IdUnitMeasurement, Code,
										[Name], [Description], Barcode, IsProduct, RegisterDate, RegisterUser)
	SELECT	i.Id, i.IdAccount, i.IdCustomer, i.IdResolution, i.IdAccountingItem, i.IdUnitMeasurement, i.Code,
			i.Name, i.Description, i.Barcode, i.IsProduct, i.RegisterDate, i.RegisterUser
	  FROM	[Item] i
	 WHERE	i.Id IN (SELECT DISTINCT IdItem FROM @FileDetailExportsTemp)
	   AND	i.IsProduct = 1
	
	INSERT INTO @FileAttachedImportTemp(Id, AttachedNumber, CustomerName, Nit, [Address], PhoneNumber, IdFileHeader)
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
				   AND	att.[Description] in ('Negocio', 'Trabajo'))[Address],
			(	SELECT	TOP 1 pp.Number
				  FROM	[Phone] pp INNER JOIN [PhoneType] pt ON pp.IdPhoneType = pt.Id
				 WHERE	pp.IdPerson = s.IdPerson
				   AND	pt.[Description] in ('Trabajo'))[PhoneNumber], fh.Id
	  FROM	FileAttached fa INNER JOIN @FileHeaderImportsTemp fh ON fh.Id = fa.IdFileHeader
							INNER JOIN Supplier s ON s.IdPerson = fa.IdSupplier
							INNER JOIN Person p ON p.Id = s.IdPerson

	INSERT INTO @FileAttachedExportTemp(Id, AttachedNumber, CustomerName, Nit, [Address], PhoneNumber, IdFileHeader)
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
				   AND	att.[Description] in ('Negocio', 'Trabajo'))[Address],
			(	SELECT	TOP 1 pp.Number
				  FROM	[Phone] pp INNER JOIN [PhoneType] pt ON pp.IdPhoneType = pt.Id
				 WHERE	pp.IdPerson = s.IdPerson
				   AND	pt.[Description] in ('Trabajo'))[PhoneNumber], fh.id
	  FROM	FileAttached fa INNER JOIN @FileHeaderExportsTemp fh ON fh.Id = fa.IdFileHeader
							INNER JOIN Supplier s ON s.IdPerson = fa.IdSupplier
							INNER JOIN Person p ON p.Id = s.IdPerson
	
	DECLARE	@HeaderListCounter	INT = (SELECT COUNT(*) FROM @HeaderListTable)

	IF(@HeaderListCounter > 0)
		BEGIN
			DECLARE	@ImportListCounter	INT = (SELECT COUNT(*) FROM @HeaderListTable WHERE [Type] = 'Importación'),
					@ExportListCounter	INT = (SELECT COUNT(*) FROM @HeaderListTable WHERE [Type] = 'Exportación')

			IF(@ImportListCounter > 0 AND @ExportListCounter > 0)
				BEGIN
					SELECT	fhi.id [Id_Cabecera_Importacion], fhi.IdDocument [Poliza_Importacion], fhi.AuthorizationDate [Fecha_Autorizacion],
							fhi.ExpirationDate [Fecha_Vencimiento], fhi.ExchangeRate [Tipo_Cambio], cmi.Code [Aduana_Importacion], 
							fhi.RegisterDate [Fecha_Sistema], fhi.Insurance [Seguro], fhi.Cargo [Flete], 
							(	SELECT	TOP 1 AttachedNumber
								  FROM	@FileAttachedImportTemp
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC) [Numero_Factura],
							0 [Numero_Resolucion], w.[Description] [Des_Garantia], cmi.[Name] [Des_Aduana], cu.[Name] [Des_Pais], fdi.id [Id_Detalle_Importacion], 
							fdi.TransactionLine [Linea_Importacion], fdi.ItemQuantity [Cantidad], fdi.CIFCotQuetzal [Costo_Cif_Quetzales], 
							fdi.FOCostQuetzal [Costo_Fob_Quetzales], fdi.CustomDuties [Derechos_Suspenso], fdi.Iva [Iva_Suspenso], c.IdPerson [Id_Cliente], 
							c.CustomerName [Nombre_Cliente], c.Nit [Nit_Cliente], c.[Address] [Direccion_Cliente], c.PhoneNumber [Telefono_Cliente],
							c.PersonCode [Codigo_Cliente], c.ImporterCode [Codigo_Importador_Exportador], c.ResolutionRate [Resolucion_Calificacion],
							c.ResolutionStartDate [Fecha_Resolucion], c.ResolutionEndDate [C_Vencimiento],
							(	SELECT	TOP 1 fat.CustomerName
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Nombre_Proveedor],
							(	SELECT	TOP 1 fat.Nit
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Nit_Proveedor],
							(	SELECT	TOP 1 fat.[Address]
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Direccion_Proveedor],
							(	SELECT	TOP 1 fat.PhoneNumber
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Telefono_Proveedor],
							mp.[Name] [Des_Materia_Prima], mp.Code [Codigo_Materia_Prima], aim.AccountingItem [Partida_Materia], mum.[Name] [Des_UM_Materia], 
							rm.[Name] [Des_Resolucion], fid.Quantity [Cantidad_Formula], fid.Decrease [Cantidad_Merma_Formula], fid.CIFcost [Costo_Cif_Formula], 
							fid.FOcost [Costo_Fob_Formula], fid.CustomDuties [Suspenso_Formula], fid.Iva [Iva_Formula], fid.RegisterDate [Fecha_Formula],
							fde.Id [Id_Detalle_Exportacion], fde.TransactionLine [Linea_Exportacion], fde.ItemQuantity [Cantidad_Exp], 
							fde.CIFCotQuetzal [Cif_Exp], fde.CustomDuties [Suspenso_Exp], fde.Iva [IVA_Exp], fhe.IdDocument [Poliza_Exportacion], 
							fhe.IdFileInfoConfig [Tipo_Documento], fhe.AuthorizationDate [Fecha_Documento], 
							(	SELECT	TOP 1 AttachedNumber
								  FROM	@FileAttachedExportTemp
								 WHERE	IdFileHeader = fhe.Id
								 ORDER BY Id ASC)[Factura_Exp], 
							cme.Code [Aduana_Exportacion], p.[Name] [Des_Producto], p.Code [Codigo_Producto], aip.AccountingItem [Partida_Producto],
							pum.[Name] [Des_UM_Producto],
							(IsNull(fid_a.Quantity,0) + IsNull(fid_a.Decrease,0))[Cantidad_A],
							IsNull(fid_a.CIFcost,0) [Costo_Cif_A],
							IsNull(fid_a.CustomDuties,0) [Suspenso_A],
							IsNull(fid_a.Iva,0) [IVA_A],
							(IsNull(fid_t.Quantity,0) + IsNull(fid_t.Decrease,0))[Cantidad_Transmitido],
							IsNull(fid_t.CIFcost,0) [CIF_Transmitido],
							(IsNull(fid_t.CustomDuties,0) + IsNull(fid_t.Iva,0))[Suspenso_Iva_Transmitido],
							TR.TransactionNumber Numero_Transmision
					  FROM	@FileItemDischargeTemp fid  INNER JOIN @FileDetailImportsTemp fdi ON fdi.Id = fid.IdFileDetailStock
														INNER JOIN @FileDetailExportsTemp fde ON fde.Id = fid.IdFileDetailSubstract 
														INNER JOIN @FileHeaderImportsTemp fhi ON fhi.id = fdi.IdFileHeader
														INNER JOIN @FileHeaderExportsTemp fhe ON fhe.Id = fde.IdFileHeader
														INNER JOIN @ItemRawMaterialTemp mp ON mp.Id = fdi.IdItem
														INNER JOIN @ItemProductTemp p ON p.Id = fde.IdItem
														INNER JOIN @CustomerTemp c	ON c.IdPerson = fhi.IdCustomer
														INNER JOIN [UnitMeasurement] mum	ON mum.Id = mp.IdUnitMeasurement
														INNER JOIN [UnitMeasurement] pum	ON pum.Id = p.IdUnitMeasurement
														LEFT JOIN [ResolutionAccountingItem] raim	ON raim.IdAccountingItem = mp.IdAccountingItem
																									AND raim.IdResolution = mp.IdResolution
														LEFT JOIN [Resolution] rm	ON rm.Id = raim.IdResolution
														LEFT JOIN [AccountingItem] aim	ON aim.Id = raim.IdAccountingItem
														LEFT JOIN [ResolutionAccountingItem] raip	ON raip.IdAccountingItem = p.IdAccountingItem
																									AND raip.IdResolution = p.IdResolution
														LEFT JOIN [Resolution] rp	ON rp.Id = raip.IdResolution
														LEFT JOIN [AccountingItem] aip	ON aip.Id = raip.IdAccountingItem
														LEFT JOIN [Warranty] w	ON W.Id = fhi.IdWarranty
														LEFT JOIN [Customs] cmi ON cmi.Id = fhi.IdCustom
														LEFT JOIN [Customs] cme ON cme.Id = fhe.IdCustom
														LEFT JOIN [Country] cu	ON cu.Id = fhi.IdCountry
														LEFT JOIN @FileItemDischargePastTemp fid_a ON fid_a.IdFileDetailStock = fdi.Id
														LEFT JOIN @FileItemDischargeTransmitedTemp fid_t ON fid_t.Id = fid.Id
														LEFT JOIN @TransmitedInfoTemp TR ON TR.IdFileItemDischarge = fid.Id
														INNER JOIN @HeaderListTable hlti ON fhi.Id = hlti.IdFileHeaderTemp 
														INNER JOIN @HeaderListTable hlte ON fhe.Id = hlte.IdFileHeaderTemp
				END
			ELSE IF(@ImportListCounter > 0 AND @ExportListCounter <= 0)
				BEGIN
					SELECT	fhi.id [Id_Cabecera_Importacion], fhi.IdDocument [Poliza_Importacion], fhi.AuthorizationDate [Fecha_Autorizacion],
							fhi.ExpirationDate [Fecha_Vencimiento], fhi.ExchangeRate [Tipo_Cambio], cmi.Code [Aduana_Importacion], 
							fhi.RegisterDate [Fecha_Sistema], fhi.Insurance [Seguro], fhi.Cargo [Flete], 
							(	SELECT	TOP 1 AttachedNumber
								  FROM	@FileAttachedImportTemp
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC) [Numero_Factura],
							0 [Numero_Resolucion], w.[Description] [Des_Garantia], cmi.[Name] [Des_Aduana], cu.[Name] [Des_Pais], fdi.id [Id_Detalle_Importacion], 
							fdi.TransactionLine [Linea_Importacion], fdi.ItemQuantity [Cantidad], fdi.CIFCotQuetzal [Costo_Cif_Quetzales], 
							fdi.FOCostQuetzal [Costo_Fob_Quetzales], fdi.CustomDuties [Derechos_Suspenso], fdi.Iva [Iva_Suspenso], c.IdPerson [Id_Cliente], 
							c.CustomerName [Nombre_Cliente], c.Nit [Nit_Cliente], c.[Address] [Direccion_Cliente], c.PhoneNumber [Telefono_Cliente],
							c.PersonCode [Codigo_Cliente], c.ImporterCode [Codigo_Importador_Exportador], c.ResolutionRate [Resolucion_Calificacion],
							c.ResolutionStartDate [Fecha_Resolucion], c.ResolutionEndDate [C_Vencimiento],
							(	SELECT	TOP 1 fat.CustomerName
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Nombre_Proveedor],
							(	SELECT	TOP 1 fat.Nit
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Nit_Proveedor],
							(	SELECT	TOP 1 fat.[Address]
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Direccion_Proveedor],
							(	SELECT	TOP 1 fat.PhoneNumber
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Telefono_Proveedor],
							mp.[Name] [Des_Materia_Prima], mp.Code [Codigo_Materia_Prima], aim.AccountingItem [Partida_Materia], mum.[Name] [Des_UM_Materia], 
							rm.[Name] [Des_Resolucion], fid.Quantity [Cantidad_Formula], fid.Decrease [Cantidad_Merma_Formula], fid.CIFcost [Costo_Cif_Formula], 
							fid.FOcost [Costo_Fob_Formula], fid.CustomDuties [Suspenso_Formula], fid.Iva [Iva_Formula], fid.RegisterDate [Fecha_Formula],
							fde.Id [Id_Detalle_Exportacion], fde.TransactionLine [Linea_Exportacion], fde.ItemQuantity [Cantidad_Exp], 
							fde.CIFCotQuetzal [Cif_Exp], fde.CustomDuties [Suspenso_Exp], fde.Iva [IVA_Exp], fhe.IdDocument [Poliza_Exportacion], 
							fhe.IdFileInfoConfig [Tipo_Documento], fhe.AuthorizationDate [Fecha_Documento], 
							(	SELECT	TOP 1 AttachedNumber
								  FROM	@FileAttachedExportTemp
								 WHERE	IdFileHeader = fhe.Id
								 ORDER BY Id ASC)[Factura_Exp], 
							cme.Code [Aduana_Exportacion], p.[Name] [Des_Producto], p.Code [Codigo_Producto], aip.AccountingItem [Partida_Producto],
							pum.[Name] [Des_UM_Producto],
							(IsNull(fid_a.Quantity,0) + IsNull(fid_a.Decrease,0))[Cantidad_A],
							IsNull(fid_a.CIFcost,0) [Costo_Cif_A],
							IsNull(fid_a.CustomDuties,0) [Suspenso_A],
							IsNull(fid_a.Iva,0) [IVA_A],
							(IsNull(fid_t.Quantity,0) + IsNull(fid_t.Decrease,0))[Cantidad_Transmitido],
							IsNull(fid_t.CIFcost,0) [CIF_Transmitido],
							(IsNull(fid_t.CustomDuties,0) + IsNull(fid_t.Iva,0))[Suspenso_Iva_Transmitido],
							TR.TransactionNumber Numero_Transmision
					  FROM	@FileItemDischargeTemp fid  INNER JOIN @FileDetailImportsTemp fdi ON fdi.Id = fid.IdFileDetailStock
														INNER JOIN @FileDetailExportsTemp fde ON fde.Id = fid.IdFileDetailSubstract 
														INNER JOIN @FileHeaderImportsTemp fhi ON fhi.id = fdi.IdFileHeader
														INNER JOIN @FileHeaderExportsTemp fhe ON fhe.Id = fde.IdFileHeader
														INNER JOIN @ItemRawMaterialTemp mp ON mp.Id = fdi.IdItem
														INNER JOIN @ItemProductTemp p ON p.Id = fde.IdItem
														INNER JOIN @CustomerTemp c	ON c.IdPerson = fhi.IdCustomer
														INNER JOIN [UnitMeasurement] mum	ON mum.Id = mp.IdUnitMeasurement
														INNER JOIN [UnitMeasurement] pum	ON pum.Id = p.IdUnitMeasurement
														LEFT JOIN [ResolutionAccountingItem] raim	ON raim.IdAccountingItem = mp.IdAccountingItem
																									AND raim.IdResolution = mp.IdResolution
														LEFT JOIN [Resolution] rm	ON rm.Id = raim.IdResolution
														LEFT JOIN [AccountingItem] aim	ON aim.Id = raim.IdAccountingItem
														LEFT JOIN [ResolutionAccountingItem] raip	ON raip.IdAccountingItem = p.IdAccountingItem
																									AND raip.IdResolution = p.IdResolution
														LEFT JOIN [Resolution] rp	ON rp.Id = raip.IdResolution
														LEFT JOIN [AccountingItem] aip	ON aip.Id = raip.IdAccountingItem
														INNER JOIN [Warranty] w	ON W.Id = fhi.IdWarranty
														LEFT JOIN [Customs] cmi ON cmi.Id = fhi.IdCustom
														LEFT JOIN [Customs] cme ON cme.Id = fhe.IdCustom
														LEFT JOIN [Country] cu	ON cu.Id = fhi.IdCountry
														LEFT JOIN @FileItemDischargePastTemp fid_a ON fid_a.IdFileDetailStock = fdi.Id
														LEFT JOIN @FileItemDischargeTransmitedTemp fid_t ON fid_t.Id = fid.Id
														LEFT JOIN @TransmitedInfoTemp TR ON TR.IdFileItemDischarge = fid.Id
														INNER JOIN @HeaderListTable hlti ON fhi.Id = hlti.IdFileHeaderTemp
				END
			ELSE IF(@ImportListCounter <= 0 AND @ExportListCounter > 0)
				BEGIN
					SELECT	fhi.id [Id_Cabecera_Importacion], fhi.IdDocument [Poliza_Importacion], fhi.AuthorizationDate [Fecha_Autorizacion],
							fhi.ExpirationDate [Fecha_Vencimiento], fhi.ExchangeRate [Tipo_Cambio], cmi.Code [Aduana_Importacion], 
							fhi.RegisterDate [Fecha_Sistema], fhi.Insurance [Seguro], fhi.Cargo [Flete], 
							(	SELECT	TOP 1 AttachedNumber
								  FROM	@FileAttachedImportTemp
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC) [Numero_Factura],
							0 [Numero_Resolucion], w.[Description] [Des_Garantia], cmi.[Name] [Des_Aduana], cu.[Name] [Des_Pais], fdi.id [Id_Detalle_Importacion], 
							fdi.TransactionLine [Linea_Importacion], fdi.ItemQuantity [Cantidad], fdi.CIFCotQuetzal [Costo_Cif_Quetzales], 
							fdi.FOCostQuetzal [Costo_Fob_Quetzales], fdi.CustomDuties [Derechos_Suspenso], fdi.Iva [Iva_Suspenso], c.IdPerson [Id_Cliente], 
							c.CustomerName [Nombre_Cliente], c.Nit [Nit_Cliente], c.[Address] [Direccion_Cliente], c.PhoneNumber [Telefono_Cliente],
							c.PersonCode [Codigo_Cliente], c.ImporterCode [Codigo_Importador_Exportador], c.ResolutionRate [Resolucion_Calificacion],
							c.ResolutionStartDate [Fecha_Resolucion], c.ResolutionEndDate [C_Vencimiento],
							(	SELECT	TOP 1 fat.CustomerName
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Nombre_Proveedor],
							(	SELECT	TOP 1 fat.Nit
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Nit_Proveedor],
							(	SELECT	TOP 1 fat.[Address]
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Direccion_Proveedor],
							(	SELECT	TOP 1 fat.PhoneNumber
								  FROM	@FileAttachedImportTemp fat
								 WHERE	IdFileHeader = fhi.Id
								 ORDER BY Id ASC)[Telefono_Proveedor],
							mp.[Name] [Des_Materia_Prima], mp.Code [Codigo_Materia_Prima], aim.AccountingItem [Partida_Materia], mum.[Name] [Des_UM_Materia], 
							rm.[Name] [Des_Resolucion], fid.Quantity [Cantidad_Formula], fid.Decrease [Cantidad_Merma_Formula], fid.CIFcost [Costo_Cif_Formula], 
							fid.FOcost [Costo_Fob_Formula], fid.CustomDuties [Suspenso_Formula], fid.Iva [Iva_Formula], fid.RegisterDate [Fecha_Formula],
							fde.Id [Id_Detalle_Exportacion], fde.TransactionLine [Linea_Exportacion], fde.ItemQuantity [Cantidad_Exp], 
							fde.CIFCotQuetzal [Cif_Exp], fde.CustomDuties [Suspenso_Exp], fde.Iva [IVA_Exp], fhe.IdDocument [Poliza_Exportacion], 
							fhe.IdFileInfoConfig [Tipo_Documento], fhe.AuthorizationDate [Fecha_Documento], 
							(	SELECT	TOP 1 AttachedNumber
								  FROM	@FileAttachedExportTemp
								 WHERE	IdFileHeader = fhe.Id
								 ORDER BY Id ASC)[Factura_Exp], 
							cme.Code [Aduana_Exportacion], p.[Name] [Des_Producto], p.Code [Codigo_Producto], aip.AccountingItem [Partida_Producto],
							pum.[Name] [Des_UM_Producto],
							(IsNull(fid_a.Quantity,0) + IsNull(fid_a.Decrease,0))[Cantidad_A],
							IsNull(fid_a.CIFcost,0) [Costo_Cif_A],
							IsNull(fid_a.CustomDuties,0) [Suspenso_A],
							IsNull(fid_a.Iva,0) [IVA_A],
							(IsNull(fid_t.Quantity,0) + IsNull(fid_t.Decrease,0))[Cantidad_Transmitido],
							IsNull(fid_t.CIFcost,0) [CIF_Transmitido],
							(IsNull(fid_t.CustomDuties,0) + IsNull(fid_t.Iva,0))[Suspenso_Iva_Transmitido],
							TR.TransactionNumber Numero_Transmision
					  FROM	@FileItemDischargeTemp fid  INNER JOIN @FileDetailImportsTemp fdi ON fdi.Id = fid.IdFileDetailStock
														INNER JOIN @FileDetailExportsTemp fde ON fde.Id = fid.IdFileDetailSubstract 
														INNER JOIN @FileHeaderImportsTemp fhi ON fhi.id = fdi.IdFileHeader
														INNER JOIN @FileHeaderExportsTemp fhe ON fhe.Id = fde.IdFileHeader
														INNER JOIN @ItemRawMaterialTemp mp ON mp.Id = fdi.IdItem
														INNER JOIN @ItemProductTemp p ON p.Id = fde.IdItem
														INNER JOIN @CustomerTemp c	ON c.IdPerson = fhi.IdCustomer
														INNER JOIN [UnitMeasurement] mum	ON mum.Id = mp.IdUnitMeasurement
														INNER JOIN [UnitMeasurement] pum	ON pum.Id = p.IdUnitMeasurement
														LEFT JOIN [ResolutionAccountingItem] raim	ON raim.IdAccountingItem = mp.IdAccountingItem
																									AND raim.IdResolution = mp.IdResolution
														LEFT JOIN [Resolution] rm	ON rm.Id = raim.IdResolution
														LEFT JOIN [AccountingItem] aim	ON aim.Id = raim.IdAccountingItem
														LEFT JOIN [ResolutionAccountingItem] raip	ON raip.IdAccountingItem = p.IdAccountingItem
																									AND raip.IdResolution = p.IdResolution
														LEFT JOIN [Resolution] rp	ON rp.Id = raip.IdResolution
														LEFT JOIN [AccountingItem] aip	ON aip.Id = raip.IdAccountingItem
														LEFT JOIN [Warranty] w	ON W.Id = fhi.IdWarranty
														LEFT JOIN [Customs] cmi ON cmi.Id = fhi.IdCustom
														LEFT JOIN [Customs] cme ON cme.Id = fhe.IdCustom
														LEFT JOIN [Country] cu	ON cu.Id = fhi.IdCountry
														LEFT JOIN @FileItemDischargePastTemp fid_a ON fid_a.IdFileDetailStock = fdi.Id
														LEFT JOIN @FileItemDischargeTransmitedTemp fid_t ON fid_t.Id = fid.Id
														LEFT JOIN @TransmitedInfoTemp TR ON TR.IdFileItemDischarge = fid.Id 
														INNER JOIN @HeaderListTable hlte ON fhe.Id = hlte.IdFileHeaderTemp
				END
		END
	ELSE
		BEGIN
			SELECT	fhi.id [Id_Cabecera_Importacion], fhi.IdDocument [Poliza_Importacion], fhi.AuthorizationDate [Fecha_Autorizacion],
					fhi.ExpirationDate [Fecha_Vencimiento], fhi.ExchangeRate [Tipo_Cambio], cmi.Code [Aduana_Importacion], 
					fhi.RegisterDate [Fecha_Sistema], fhi.Insurance [Seguro], fhi.Cargo [Flete], 
					(	SELECT	TOP 1 AttachedNumber
						  FROM	@FileAttachedImportTemp
						 WHERE	IdFileHeader = fhi.Id
						 ORDER BY Id ASC) [Numero_Factura],
					0 [Numero_Resolucion], w.[Description] [Des_Garantia], cmi.[Name] [Des_Aduana], cu.[Name] [Des_Pais], fdi.id [Id_Detalle_Importacion], 
					fdi.TransactionLine [Linea_Importacion], fdi.ItemQuantity [Cantidad], fdi.CIFCotQuetzal [Costo_Cif_Quetzales], 
					fdi.FOCostQuetzal [Costo_Fob_Quetzales], fdi.CustomDuties [Derechos_Suspenso], fdi.Iva [Iva_Suspenso], c.IdPerson [Id_Cliente], 
					c.CustomerName [Nombre_Cliente], c.Nit [Nit_Cliente], c.[Address] [Direccion_Cliente], c.PhoneNumber [Telefono_Cliente],
					c.PersonCode [Codigo_Cliente], c.ImporterCode [Codigo_Importador_Exportador], c.ResolutionRate [Resolucion_Calificacion],
					c.ResolutionStartDate [Fecha_Resolucion], c.ResolutionEndDate [C_Vencimiento],
					(	SELECT	TOP 1 fat.CustomerName
						  FROM	@FileAttachedImportTemp fat
						 WHERE	IdFileHeader = fhi.Id
						 ORDER BY Id ASC)[Nombre_Proveedor],
					(	SELECT	TOP 1 fat.Nit
						  FROM	@FileAttachedImportTemp fat
						 WHERE	IdFileHeader = fhi.Id
						 ORDER BY Id ASC)[Nit_Proveedor],
					(	SELECT	TOP 1 fat.[Address]
						  FROM	@FileAttachedImportTemp fat
						 WHERE	IdFileHeader = fhi.Id
						 ORDER BY Id ASC)[Direccion_Proveedor],
					(	SELECT	TOP 1 fat.PhoneNumber
						  FROM	@FileAttachedImportTemp fat
						 WHERE	IdFileHeader = fhi.Id
						 ORDER BY Id ASC)[Telefono_Proveedor],
					mp.[Name] [Des_Materia_Prima], mp.Code [Codigo_Materia_Prima], aim.AccountingItem [Partida_Materia], mum.[Name] [Des_UM_Materia], 
					rm.[Name] [Des_Resolucion], fid.Quantity [Cantidad_Formula], fid.Decrease [Cantidad_Merma_Formula], fid.CIFcost [Costo_Cif_Formula], 
					fid.FOcost [Costo_Fob_Formula], fid.CustomDuties [Suspenso_Formula], fid.Iva [Iva_Formula], fid.RegisterDate [Fecha_Formula],
					fde.Id [Id_Detalle_Exportacion], fde.TransactionLine [Linea_Exportacion], fde.ItemQuantity [Cantidad_Exp], 
					fde.CIFCotQuetzal [Cif_Exp], fde.CustomDuties [Suspenso_Exp], fde.Iva [IVA_Exp], fhe.IdDocument [Poliza_Exportacion], 
					fhe.IdFileInfoConfig [Tipo_Documento], fhe.AuthorizationDate [Fecha_Documento], 
					(	SELECT	TOP 1 AttachedNumber
						  FROM	@FileAttachedExportTemp
						 WHERE	IdFileHeader = fhe.Id
						 ORDER BY Id ASC)[Factura_Exp], 
					cme.Code [Aduana_Exportacion], p.[Name] [Des_Producto], p.Code [Codigo_Producto], aip.AccountingItem [Partida_Producto],
					pum.[Name] [Des_UM_Producto],
					(IsNull(fid_a.Quantity,0) + IsNull(fid_a.Decrease,0))[Cantidad_A],
					IsNull(fid_a.CIFcost,0) [Costo_Cif_A],
					IsNull(fid_a.CustomDuties,0) [Suspenso_A],
					IsNull(fid_a.Iva,0) [IVA_A],
					(IsNull(fid_t.Quantity,0) + IsNull(fid_t.Decrease,0))[Cantidad_Transmitido],
					IsNull(fid_t.CIFcost,0) [CIF_Transmitido],
					(IsNull(fid_t.CustomDuties,0) + IsNull(fid_t.Iva,0))[Suspenso_Iva_Transmitido],
					TR.TransactionNumber Numero_Transmision
			  FROM	@FileItemDischargeTemp fid  INNER JOIN @FileDetailImportsTemp fdi ON fdi.Id = fid.IdFileDetailStock
												INNER JOIN @FileDetailExportsTemp fde ON fde.Id = fid.IdFileDetailSubstract 
												INNER JOIN @FileHeaderImportsTemp fhi ON fhi.id = fdi.IdFileHeader
												INNER JOIN @FileHeaderExportsTemp fhe ON fhe.Id = fde.IdFileHeader
												INNER JOIN @ItemRawMaterialTemp mp ON mp.Id = fdi.IdItem
												INNER JOIN @ItemProductTemp p ON p.Id = fde.IdItem
												INNER JOIN @CustomerTemp c	ON c.IdPerson = fhi.IdCustomer
												INNER JOIN [UnitMeasurement] mum	ON mum.Id = mp.IdUnitMeasurement
												INNER JOIN [UnitMeasurement] pum	ON pum.Id = p.IdUnitMeasurement
												LEFT JOIN [ResolutionAccountingItem] raim	ON raim.IdAccountingItem = mp.IdAccountingItem
																							AND raim.IdResolution = mp.IdResolution
												LEFT JOIN [Resolution] rm	ON rm.Id = raim.IdResolution
												LEFT JOIN [AccountingItem] aim	ON aim.Id = raim.IdAccountingItem
												LEFT JOIN [ResolutionAccountingItem] raip	ON raip.IdAccountingItem = p.IdAccountingItem
																							AND raip.IdResolution = p.IdResolution
												LEFT JOIN [Resolution] rp	ON rp.Id = raip.IdResolution
												LEFT JOIN [AccountingItem] aip	ON aip.Id = raip.IdAccountingItem
												LEFT JOIN [Warranty] w	ON W.Id = fhi.IdWarranty
												LEFT JOIN [Customs] cmi ON cmi.Id = fhi.IdCustom
												LEFT JOIN [Customs] cme ON cme.Id = fhe.IdCustom
												LEFT JOIN [Country] cu	ON cu.Id = fhi.IdCountry
												LEFT JOIN @FileItemDischargePastTemp fid_a ON fid_a.IdFileDetailStock = fdi.Id
												LEFT JOIN @FileItemDischargeTransmitedTemp fid_t ON fid_t.Id = fid.Id
												LEFT JOIN @TransmitedInfoTemp TR ON TR.IdFileItemDischarge = fid.Id
		END
