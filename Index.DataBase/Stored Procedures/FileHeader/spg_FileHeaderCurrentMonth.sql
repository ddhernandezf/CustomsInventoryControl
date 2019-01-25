CREATE PROCEDURE [spg_FileHeaderCurrentMonth]
	@IdFileHeader		INT,
	@IdCustomer			INT,
	@IdAccount			INT,
	@IdFileInfoConfig	INT
AS
	DECLARE @TempFileInfoConfig TABLE (
		[Id] INT NOT NULL,
		[IdFileInfo] INT NOT NULL,
		[FileInfoName] VARCHAR(150) NULL,
		[DropDownName] VARCHAR(200) NULL,
		[IdFileType] INT NOT NULL,
		[IdAccount] INT NOT NULL,
		[Active] BIT NULL,
		[UseAttached] BIT NOT NULL,
		[IsSubstract] BIT NOT NULL,
		[LoadRawMaterial] BIT NOT NULL,
		[Operation]	VARCHAR(3) NULL
	)

	DECLARE @TempFileHeader TABLE (
		[Id]				INT NOT NULL,
		[IdCustomer]		INT NOT NULL,
		[IdFileInfoConfig]	INT NOT NULL,
		[IdDocument]		VARCHAR(100) NULL,
		[AuthorizationDate]	DATETIME NULL,
		[ExpantionDate]		DATETIME NULL,
		[ExpirationDate]	DATETIME NULL,
		[DocumentDate]		DATETIME NULL,
		[ArrivalDate] DATETIME NULL,
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
		[CIFTotal] DECIMAL(18,6) NULL,
		[LinesTotal] INT NULL,
		[RegisterDate]		DATETIME NOT NULL,
		[RegisterUser]		VARCHAR(60) NOT NULL,
		[CreateDate]		DATETIME NOT NULL,
		[UpdateDate]		DATETIME NULL
	)

	IF(ISNULL(@IdFileInfoConfig, 0) = 0)
		BEGIN
			IF(ISNULL(@IdAccount, 0) = 0)
				BEGIN
					INSERT INTO @TempFileInfoConfig(Id, IdFileInfo, FileInfoName, DropDownName, IdFileType, IdAccount, UseAttached,
													IsSubstract, Operation, LoadRawMaterial, Active)
					SELECT	fc.Id, fc.IdFileInfo, fi.[Name], CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownName], fc.IdFileType, 
							fc.IdAccount, fc.UseAttached, fc.IsSubstract,
							CASE WHEN fc.IsSubstract = 1 
								THEN '(-)'
								ELSE '(+)'
							END[Operation], fc.LoadRawMaterial, fc.Active
					  FROM	[FileInfoConfig] fc INNER JOIN [FileInfo] fi ON fi.Id = fc.IdFileInfo
												INNER JOIN [FileInfoType] ft ON ft.Id = fc.IdFileType
				END
			ELSE
				BEGIN
					INSERT INTO @TempFileInfoConfig(Id, IdFileInfo, FileInfoName, DropDownName, IdFileType, IdAccount, UseAttached,
													IsSubstract, Operation, LoadRawMaterial, Active)
					SELECT	fc.Id, fc.IdFileInfo, fi.[Name], CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownName], fc.IdFileType, 
							fc.IdAccount, fc.UseAttached, fc.IsSubstract,
							CASE WHEN fc.IsSubstract = 1 
								THEN '(-)'
								ELSE '(+)'
							END[Operation], fc.LoadRawMaterial, fc.Active
					  FROM	[FileInfoConfig] fc INNER JOIN [FileInfo] fi ON fi.Id = fc.IdFileInfo
												INNER JOIN [FileInfoType] ft ON ft.Id = fc.IdFileType
					 WHERE	fc.IdAccount = @IdAccount
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdAccount, 0) = 0)
				BEGIN
					INSERT INTO @TempFileInfoConfig(Id, IdFileInfo, FileInfoName, DropDownName, IdFileType, IdAccount, UseAttached,
													IsSubstract, Operation, LoadRawMaterial, Active)
					SELECT	fc.Id, fc.IdFileInfo, fi.[Name], CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownName], fc.IdFileType, 
							fc.IdAccount, fc.UseAttached, fc.IsSubstract,
							CASE WHEN fc.IsSubstract = 1 
								THEN '(-)'
								ELSE '(+)'
							END[Operation], fc.LoadRawMaterial, fc.Active
					  FROM	[FileInfoConfig] fc INNER JOIN [FileInfo] fi ON fi.Id = fc.IdFileInfo
												INNER JOIN [FileInfoType] ft ON ft.Id = fc.IdFileType
					 WHERE	fc.Id = @IdFileInfoConfig
				END
			ELSE
				BEGIN
					INSERT INTO @TempFileInfoConfig(Id, IdFileInfo, FileInfoName, DropDownName, IdFileType, IdAccount, UseAttached,
													IsSubstract, Operation, LoadRawMaterial, Active)
					SELECT	fc.Id, fc.IdFileInfo, fi.[Name], CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownName], fc.IdFileType, 
							fc.IdAccount, fc.UseAttached, fc.IsSubstract,
							CASE WHEN fc.IsSubstract = 1 
								THEN '(-)'
								ELSE '(+)'
							END[Operation], fc.LoadRawMaterial, fc.Active
					  FROM	[FileInfoConfig] fc INNER JOIN [FileInfo] fi ON fi.Id = fc.IdFileInfo
												INNER JOIN [FileInfoType] ft ON ft.Id = fc.IdFileType
					 WHERE	fc.Id = @IdFileInfoConfig
					   AND	fc.IdAccount = @IdAccount
				END
		END
	
	IF(ISNULL(@IdFileHeader, 0) = 0)
		BEGIN
			IF(ISNULL(@IdCustomer, 0) = 0)
				BEGIN
					IF(ISNULL(@IdAccount, 0) = 0)
						BEGIN
							INSERT INTO @TempFileHeader (Id, IdCustomer, IdFileInfoConfig, IdDocument, AuthorizationDate, ExpantionDate,
														ExpirationDate, DocumentDate, ArrivalDate, ExchangeRate, Insurance, Cargo, IdCustom,
														IdCountry, IdWarranty, IdCellar, IdState, IdCurrency, IdResolution, IdAccount, Reviewed,
														CIFTotal, LinesTotal, RegisterDate, RegisterUser, CreateDate, UpdateDate)
							SELECT	fh.Id, fh.IdCustomer, fh.IdFileInfoConfig, fh.IdDocument, fh.AuthorizationDate, fh.ExpantionDate,
									fh.ExpirationDate, fh.DocumentDate, fh.ArrivalDate, fh.ExchangeRate, fh.Insurance, fh.Cargo, fh.IdCustom,
									fh.IdCountry, fh.IdWarranty, fh.IdCellar, fh.IdState, fh.IdCurrency, fh.IdResolution, fh.IdAccount, fh.Reviewed,
									fh.CIFTotal, fh.LinesTotal, fh.RegisterDate, fh.RegisterUser, fh.CreateDate, fh.UpdateDate
							  FROM	[FileHeader] fh INNER JOIN @TempFileInfoConfig fi ON fh.IdFileInfoConfig = fi.Id
							 WHERE	MONTH(fh.CreateDate) = MONTH(GETDATE())
							 AND	YEAR(fh.CreateDate) = YEAR(GETDATE())
						END
					ELSE
						BEGIN
							INSERT INTO @TempFileHeader (Id, IdCustomer, IdFileInfoConfig, IdDocument, AuthorizationDate, ExpantionDate,
														ExpirationDate, DocumentDate, ArrivalDate, ExchangeRate, Insurance, Cargo, IdCustom,
														IdCountry, IdWarranty, IdCellar, IdState, IdCurrency, IdResolution, IdAccount, Reviewed,
														CIFTotal, LinesTotal, RegisterDate, RegisterUser, CreateDate, UpdateDate)
							SELECT	fh.Id, fh.IdCustomer, fh.IdFileInfoConfig, fh.IdDocument, fh.AuthorizationDate, fh.ExpantionDate,
									fh.ExpirationDate, fh.DocumentDate, fh.ArrivalDate, fh.ExchangeRate, fh.Insurance, fh.Cargo, fh.IdCustom,
									fh.IdCountry, fh.IdWarranty, fh.IdCellar, fh.IdState, fh.IdCurrency, fh.IdResolution, fh.IdAccount, fh.Reviewed,
									fh.CIFTotal, fh.LinesTotal, fh.RegisterDate, fh.RegisterUser, fh.CreateDate, fh.UpdateDate
							  FROM	[FileHeader] fh INNER JOIN @TempFileInfoConfig fi ON fh.IdFileInfoConfig = fi.Id
							 WHERE	fh.IdAccount = @IdAccount
							   AND	MONTH(fh.CreateDate) = MONTH(GETDATE())
							   AND	YEAR(fh.CreateDate) = YEAR(GETDATE())
						END
				END
			ELSE
				BEGIN
					IF(ISNULL(@IdAccount, 0) = 0)
						BEGIN
							INSERT INTO @TempFileHeader (Id, IdCustomer, IdFileInfoConfig, IdDocument, AuthorizationDate, ExpantionDate,
														ExpirationDate, DocumentDate, ArrivalDate, ExchangeRate, Insurance, Cargo, IdCustom,
														IdCountry, IdWarranty, IdCellar, IdState, IdCurrency, IdResolution, IdAccount, Reviewed,
														CIFTotal, LinesTotal, RegisterDate, RegisterUser, CreateDate, UpdateDate)
							SELECT	fh.Id, fh.IdCustomer, fh.IdFileInfoConfig, fh.IdDocument, fh.AuthorizationDate, fh.ExpantionDate,
									fh.ExpirationDate, fh.DocumentDate, fh.ArrivalDate, fh.ExchangeRate, fh.Insurance, fh.Cargo, fh.IdCustom,
									fh.IdCountry, fh.IdWarranty, fh.IdCellar, fh.IdState, fh.IdCurrency, fh.IdResolution, fh.IdAccount, fh.Reviewed,
									fh.CIFTotal, fh.LinesTotal, fh.RegisterDate, fh.RegisterUser, fh.CreateDate, fh.UpdateDate
							  FROM	[FileHeader] fh INNER JOIN @TempFileInfoConfig fi ON fh.IdFileInfoConfig = fi.Id
							 WHERE	fh.IdCustomer = @IdCustomer
							   AND	MONTH(fh.CreateDate) = MONTH(GETDATE())
							   AND	YEAR(fh.CreateDate) = YEAR(GETDATE())
						END
					ELSE
						BEGIN
							INSERT INTO @TempFileHeader (Id, IdCustomer, IdFileInfoConfig, IdDocument, AuthorizationDate, ExpantionDate,
														ExpirationDate, DocumentDate, ArrivalDate, ExchangeRate, Insurance, Cargo, IdCustom,
														IdCountry, IdWarranty, IdCellar, IdState, IdCurrency, IdResolution, IdAccount, Reviewed,
														CIFTotal, LinesTotal, RegisterDate, RegisterUser, CreateDate, UpdateDate)
							SELECT	fh.Id, fh.IdCustomer, fh.IdFileInfoConfig, fh.IdDocument, fh.AuthorizationDate, fh.ExpantionDate,
									fh.ExpirationDate, fh.DocumentDate, fh.ArrivalDate, fh.ExchangeRate, fh.Insurance, fh.Cargo, fh.IdCustom,
									fh.IdCountry, fh.IdWarranty, fh.IdCellar, fh.IdState, fh.IdCurrency, fh.IdResolution, fh.IdAccount, fh.Reviewed,
									fh.CIFTotal, fh.LinesTotal, fh.RegisterDate, fh.RegisterUser, fh.CreateDate, fh.UpdateDate
							  FROM	[FileHeader] fh INNER JOIN @TempFileInfoConfig fi ON fh.IdFileInfoConfig = fi.Id
							 WHERE	fh.IdCustomer = @IdCustomer
							   AND	FH.IdAccount = @IdAccount
							   AND	MONTH(fh.CreateDate) = MONTH(GETDATE())
							   AND	YEAR(fh.CreateDate) = YEAR(GETDATE())
						END
				END
		END
	ELSE
		BEGIN
			INSERT INTO @TempFileHeader (Id, IdCustomer, IdFileInfoConfig, IdDocument, AuthorizationDate, ExpantionDate,
											ExpirationDate, DocumentDate, ArrivalDate, ExchangeRate, Insurance, Cargo, IdCustom,
											IdCountry, IdWarranty, IdCellar, IdState, IdCurrency, IdResolution, IdAccount, Reviewed,
											CIFTotal, LinesTotal, RegisterDate, RegisterUser, CreateDate, UpdateDate)
			SELECT	fh.Id, fh.IdCustomer, fh.IdFileInfoConfig, fh.IdDocument, fh.AuthorizationDate, fh.ExpantionDate,
					fh.ExpirationDate, fh.DocumentDate, fh.ArrivalDate, fh.ExchangeRate, fh.Insurance, fh.Cargo, fh.IdCustom,
					fh.IdCountry, fh.IdWarranty, fh.IdCellar, fh.IdState, fh.IdCurrency, fh.IdResolution, fh.IdAccount, fh.Reviewed,
					fh.CIFTotal, fh.LinesTotal, fh.RegisterDate, fh.RegisterUser, fh.CreateDate, fh.UpdateDate
			  FROM	[FileHeader] fh INNER JOIN @TempFileInfoConfig fi ON fh.IdFileInfoConfig = fi.Id
			 WHERE	fh.Id = @IdFileHeader
			   AND	MONTH(fh.CreateDate) = MONTH(GETDATE())
		END

	SELECT	TOP 25 fh.Id, fh.IdCustomer, fh.IdFileInfoConfig, fi.DropDownName[FileName], fi.Operation, fi.LoadRawMaterial, fi.IsSubstract,
			fh.IdDocument, fh.AuthorizationDate, fh.ExpantionDate, fh.ExpirationDate,
			fh.DocumentDate, fh.ArrivalDate, fh.ExchangeRate, 
			CASE	WHEN fh.ExchangeRate IS NULL AND fh.Insurance IS NULL THEN NULL
					WHEN fh.ExchangeRate IS NULL AND fh.Insurance IS NOT NULL THEN fh.Insurance
					WHEN fh.ExchangeRate IS NOT NULL AND fh.Insurance IS NULL THEN NULL
					WHEN fh.ExchangeRate IS NOT NULL AND fh.Insurance IS NOT NULL THEN 
					CASE WHEN fh.ExchangeRate = 0
						THEN
							fh.Insurance 
						ELSE
							(CONVERT(DECIMAL(18,6), (fh.Insurance/fh.ExchangeRate)))
					END
			END[Insurance],
			CASE	WHEN fh.ExchangeRate IS NULL AND fh.Cargo IS NULL THEN NULL
					WHEN fh.ExchangeRate IS NULL AND fh.Cargo IS NOT NULL THEN fh.Insurance
					WHEN fh.ExchangeRate IS NOT NULL AND fh.Cargo IS NULL THEN NULL
					WHEN fh.ExchangeRate IS NOT NULL AND fh.Cargo IS NOT NULL THEN 
					CASE WHEN fh.ExchangeRate = 0
						THEN
							fh.Cargo 
						ELSE
							(CONVERT(DECIMAL(18,6), (fh.Cargo/fh.ExchangeRate)))
					END
			END[Cargo], 
			fh.IdCustom, cm.[Name][CustomName],
			fh.IdCountry, c.[Name][CountryName], fh.IdWarranty, w.[Name][WarrantyName],
			fh.IdCellar, CL.[Name][CellarName], fh.IdState, st.[Name][StateName],
			fh.IdCurrency, cr.[Name][CurrencyName], fh.IdResolution, r.[Name][ResolutionName],
			fh.IdAccount, a.[Name][AccountName], fh.Reviewed, fh.CIFTotal, fh.LinesTotal, fh.RegisterDate,
			fh.RegisterUser, fh.CreateDate, fh.UpdateDate, fi.UseAttached, fa.AttachedNumber[Facturas], fi.Active[ConfigActive]
	  FROM	@TempFileHeader fh INNER JOIN @TempFileInfoConfig fi ON fh.IdFileInfoConfig = fi.Id
							   LEFT OUTER JOIN [Customs] cm ON fh.IdCustom = cm.Id
							   LEFT OUTER JOIN [Country] c ON fh.IdCountry = c.Id
							   LEFT OUTER JOIN [Warranty] w ON fh.IdWarranty = w.Id
							   LEFT OUTER JOIN [Cellar] cl ON fh.IdCellar = cl.Id
							   INNER JOIN [State] st ON fh.IdState = st.Id
							   LEFT OUTER JOIN [Currency] cr ON fh.IdCurrency = cr.Id
							   LEFT OUTER JOIN [Resolution] r ON fh.IdResolution = r.Id
							   INNER JOIN [Account] a ON fh.IdAccount = a.Id
							   LEFT OUTER JOIN [FileAttached] fa ON fh.Id = fa.IdFileHeader
	ORDER BY fh.RegisterDate desc