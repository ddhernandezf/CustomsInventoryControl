CREATE PROCEDURE [dbo].[spu_FileHeader]
	@Id					INT,
	@IdCustomer			INT,
	@IdFileInfoConfig	INT,
	@IdDocument			VARCHAR(100),
	@AuthorizationDate	DATETIME,
	@ExpantionDate		DATETIME,
	@ExpirationDate		DATETIME,
	@DocumentDate		DATETIME,
	@ArrivalDate		DATETIME,
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
	IF EXISTS(	SELECT	*
				  FROM	FileItemDischarge fid INNER JOIN FileDetail fde ON fid.IdFileDetailSubstract = fde.Id
											  INNER JOIN FileDetail fdi ON fid.IdFileDetailStock = fdi.Id
											  INNER JOIN FileHeader fhi ON fdi.IdFileHeader = fhi.Id
				 WHERE	fde.IdFileHeader = @Id
				   AND	CONVERT(DATE, fhi.AuthorizationDate) > @AuthorizationDate)
		BEGIN
			RAISERROR (N'No se puede cambiar la fecha del documento debido a que afectaria diversos registros ya operados en los descargos.',16,1);
		END
	ELSE
		BEGIN
			DECLARE @ExpDate		DATETIME,
					@Monts			INT,
					@NewInsurance	DECIMAL(18,6),
					@NewCargo		DECIMAL(18,6)

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

			UPDATE	[FileHeader]
			   SET	IdCustomer = @IdCustomer,
					IdFileInfoConfig = @IdFileInfoConfig,
					IdDocument = @IdDocument,
					AuthorizationDate = @AuthorizationDate,
					ExpantionDate = @ExpantionDate,
					ExpirationDate= @ExpDate,
					DocumentDate = @DocumentDate,
					ArrivalDate = @ArrivalDate,
					ExchangeRate = @ExchangeRate,
					Insurance = @NewInsurance,
					Cargo = @NewCargo,
					IdCustom = @IdCustom,
					IdCountry = @IdCountry,
					IdWarranty = @IdWarranty,
					IdCellar = @IdCellar,
					IdCurrency = @IdCurrency,
					IdResolution = @IdResolution,
					IdAccount = @IdAccount,
					CIFTotal = @CIFTotal,
					LinesTotal = @LinesTotal,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser,
					UpdateDate = GETDATE()
			 WHERE	Id = @Id

			DECLARE	@UseAttached BIT = (SELECT	UseAttached FROM [FileInfoConfig] WHERE Id = @IdFileInfoConfig),
					@AttachedCounter INT = (SELECT COUNT(*) FROM FileAttached WHERE IdFileHeader = @Id);

			IF(ISNULL(@Facturas, '') <> '')
				BEGIN
					IF( @AttachedCounter = 0)
						BEGIN
							INSERT INTO FileAttached(IdFileHeader, IdSupplier, [Description], AttachedNumber, AttachedDate, RegisterDate, RegisterUser)
							VALUES(@Id, NULL, 'FACTURA',@Facturas, NULL, GETDATE(), @RegisterUser);
						END
					ELSE IF( @AttachedCounter = 1)
						BEGIN
							UPDATE	FileAttached
							   SET	AttachedNumber = @Facturas,
									RegisterDate = GETDATE(),
									RegisterUser = @RegisterUser
							 WHERE	Id = (SELECT TOP 1 Id FROM FileAttached WHERE IdFileHeader = @Id);
						END
					ELSE IF( @AttachedCounter > 1)
						BEGIN
							DELETE FROM FileAttached WHERE IdFileHeader = @Id;

							INSERT INTO FileAttached(IdFileHeader, IdSupplier, [Description], AttachedNumber, AttachedDate, RegisterDate, RegisterUser)
							VALUES(@Id, NULL, 'FACTURA',@Facturas, NULL, GETDATE(), @RegisterUser);
						END
				END
			ELSE
				BEGIN
					IF(@UseAttached = 0 AND @AttachedCounter > 0)
						BEGIN
							DELETE FROM FileAttached WHERE IdFileHeader = @Id;
						END
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
				 WHERE	fh.Id = @Id;
		END	