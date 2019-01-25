CREATE PROCEDURE [dbo].[spi_FileHeader]
	@IdCustomer			INT,
	@IdFileInfoConfig		INT,
	@IdDocument			VARCHAR(100),
	@AuthorizationDate	DATETIME,
	@ExpantionDate		DATETIME,
	@ExpirationDate		DATETIME,
	@ArrivalDate		DATETIME,
	@DocumentDate		DATETIME,
	@ExchangeRate		DECIMAL(18,6),
	@Insurance			DECIMAL(18,6),
	@Cargo				DECIMAL(18,6),
	@IdCustom			INT,
	@IdCountry			INT,
	@IdWarranty			INT,
	@IdCellar			INT,
	@IdCurrency			INT,
	@IdResolution		INT,
	@IdAccount			INT,
	@CIFTotal			DECIMAL(18,6),
	@LinesTotal			INT,
	@Facturas			VARCHAR(1000),
	@RegisterUser		VARCHAR(60)
AS
	IF NOT EXISTS(	SELECT	*
					  FROM	FileInfoConfig
					 WHERE	Id = @IdFileInfoConfig
					   AND	Active = 1)
		BEGIN
			RAISERROR (N'Este tipo de documento se encuentra inactivo. No puede crearse un nuevo documento con este tipo de documento.',16,1);
		END
	ELSE
		BEGIN
			IF NOT EXISTS(	SELECT	*
							  FROM	[FileMasterDisplay]
							 WHERE	IdFileInfoConfig = @IdFileInfoConfig)
			BEGIN
				RAISERROR (N'No han sido configurado los campos para esta configuración',16,1);
			END
	
			IF EXISTS(	SELECT	*
						  FROM	[FileHeader]
						 WHERE	IdCustomer = @IdCustomer
						   AND	IdAccount = @IdAccount
						   AND	IdDocument = @IdDocument)
			BEGIN
				RAISERROR (N'Ya cuenta con un documento número %s para la combinación de este cliente y cuenta seleccionada.',16,1, @IdDocument);
			END
			ELSE
			BEGIN
				DECLARE @IdState		INT,
						@ExpDate		DATETIME,
						@Monts			INT,
						@NewInsurance	DECIMAL(18,6),
						@NewCargo		DECIMAL(18,6)

				SELECT @IdState = Id FROM [State] WHERE Name = 'Ingresado';
				SELECT @Monts = ExpirateDateMonts FROM [Parameters]
		
				IF(@ExpirationDate is null)
					BEGIN
						SET @ExpDate = DATEADD(MONTH, @Monts, @AuthorizationDate);
					END
				ELSE
					BEGIN
						SET @ExpDate = @ExpirationDate;
					END
			
				SET	@NewInsurance = @Insurance * @ExchangeRate
				SET	@NewCargo = @Cargo * @ExchangeRate

				INSERT INTO [FileHeader](IdCustomer, IdFileInfoConfig, IdState, IdDocument, AuthorizationDate, ExpantionDate, ExpirationDate, DocumentDate, ArrivalDate,
										 ExchangeRate, Insurance, Cargo, IdCustom, IdCountry, IdWarranty, IdCellar, IdCurrency, IdResolution, IdAccount, CIFTotal, LinesTotal,
										 Reviewed, RegisterDate, RegisterUser, CreateDate)
				VALUES(@IdCustomer, @IdFileInfoConfig, @IdState, @IdDocument, @AuthorizationDate, @ExpantionDate, @ExpDate, @DocumentDate, @ArrivalDate,
					   @ExchangeRate, @NewInsurance, @NewCargo, @IdCustom, @IdCountry, @IdWarranty, @IdCellar, @IdCurrency, @IdResolution, @IdAccount, @CIFTotal, @LinesTotal,
					   0, GETDATE(), @RegisterUser, GETDATE());
		
				DECLARE @IdFileHeader INT;
				SET @IdFileHeader = @@IDENTITY;

				IF(ISNULL(@Facturas, '') <> '')
					BEGIN
						INSERT INTO FileAttached(IdFileHeader, IdSupplier, [Description], AttachedNumber, AttachedDate, RegisterDate, RegisterUser)
						VALUES(@IdFileHeader, NULL, 'FACTURA',@Facturas, NULL, GETDATE(), @RegisterUser);
					END

				SELECT	fh.Id, fh.IdCustomer, fh.IdFileInfoConfig, fi.Name[FileName], 
						CASE WHEN fic.IsSubstract = 1 
										THEN '(-)'
										ELSE '(+)'
									END[Operation], 
						fic.LoadRawMaterial, fic.IsSubstract,
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
						fh.RegisterUser, fh.CreateDate, fh.UpdateDate, fic.UseAttached, fa.AttachedNumber[Facturas]
				  FROM	Fileheader fh INNER JOIN FileInfoConfig fic ON fh.IdFileInfoConfig = fic.Id
									   INNER JOIN FileInfo fi ON fic.IdFileInfo = fi.Id
									   LEFT OUTER JOIN [Customs] cm ON fh.IdCustom = cm.Id
									   LEFT OUTER JOIN [Country] c ON fh.IdCountry = c.Id
									   LEFT OUTER JOIN [Warranty] w ON fh.IdWarranty = w.Id
									   LEFT OUTER JOIN [Cellar] cl ON fh.IdCellar = cl.Id
									   INNER JOIN [State] st ON fh.IdState = st.Id
									   LEFT OUTER JOIN [Currency] cr ON fh.IdCurrency = cr.Id
									   LEFT OUTER JOIN [Resolution] r ON fh.IdResolution = r.Id
									   INNER JOIN [Account] a ON fh.IdAccount = a.Id
									   LEFT OUTER JOIN [FileAttached] fa ON fh.Id = fa.IdFileHeader
				 WHERE	fh.Id = @IdFileHeader;
			END
		END