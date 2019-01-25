CREATE PROCEDURE [spu_FileDetail]
	@IdFileDetail	INT,
	@IdFileHeader	INT,
	@TranLine		INT,
	@IdItem			INT,
	@ItemQuantity	DECIMAL(18,6),
	@CIFCotQuetzal	DECIMAL(18,6),
	@FOCostQuetzal	DECIMAL(18,6),
	@CIFCotDollar	DECIMAL(18,6),
	@FOCostDollar	DECIMAL(18,6),
	@CustomDuties	DECIMAL(18,6),
	@Iva			DECIMAL(18,6),
	@TaxableBase	DECIMAL(18,6),
	@TaxRate		DECIMAL(18,6),
	@NetWeight		DECIMAL(18,6),
	@GrossWeight	DECIMAL(18,6),
	@RegisterUser	VARCHAR(60)
AS
	DECLARE	@State				VARCHAR(100),
			@IsSubstract		BIT,
			@LoadRawMaterial	BIT,
			@IdCustomer			INT,
			@IdAccount			INT,
			@IdFileInfoConfig	INT;

	SELECT	@State = UPPER(s.Name), @IsSubstract = fc.IsSubstract, @LoadRawMaterial = fc.LoadRawMaterial, @IdCustomer = f.IdCustomer,
			@IdAccount = f.IdAccount, @IdFileInfoConfig = F.IdFileInfoConfig
	  FROM	[FileHeader] f INNER JOIN [State] s ON s.Id = f.IdState
						   INNER JOIN [FileInfoConfig] fc on f.IdFileInfoConfig = fc.Id
	 WHERE	f.Id = @IdFileHeader
	
	IF(ISNULL(@TranLine, 0) = 0 AND @IsSubstract = 1)
		BEGIN
			DECLARE	@TranLineUsed	BIT,
			@TranLineReq	BIT;

			SELECT	@TranLineUsed = IsUsed, @TranLineReq = IsRequeried
			  FROM	FileDetailDisplay fdd INNER JOIN Fields f ON fdd.IdField = f.Id
			 WHERE	IdFileInfoConfig = @IdFileInfoConfig
			   AND	f.DataBaseName = 'TransactionLineS';

			IF(ISNULL(@TranLineUsed, 0) = 0 AND ISNULL(@TranLineReq, 0) = 0)
				BEGIN
					SET @TranLine = 1;
				END
		END

	IF(@State <> 'REVISADO')
		BEGIN
			DECLARE	@LastStock	INT,
					@NewStock	INT

			SELECT @LastStock = ItemQuantity FROM [FileDetail] WHERE Id = @IdFileDetail
			SELECT @NewStock = (@ItemQuantity - @LastStock)

			UPDATE	[FileDetail] 
			   SET	IdFileHeader = @IdFileHeader, 
					TransactionLine = @TranLine,
					--IdItem = @IdItem, 
					ItemQuantity = @ItemQuantity,
					CIFCotQuetzal = @CIFCotQuetzal, 
					FOCostQuetzal = @FOCostQuetzal, 
					CIFCotDollar = @CIFCotDollar, 
					FOCostDollar = @FOCostDollar,
					CustomDuties= @CustomDuties, 
					Iva = @Iva, 
					TaxableBase = @TaxableBase,
					TaxRate = @TaxRate,
					NetWeight = @NetWeight,
					GrossWeight = @GrossWeight,
					RegisterDate = GETDATE(), 
					RegisterUser = @RegisterUser
			 WHERE	Id = @IdFileDetail

			IF EXISTS(	SELECT	*
						  FROM	[ItemInventory]
						 WHERE	IdCustomer = @IdCustomer
						   AND	IdAccount = @IdAccount
						   AND	IdFileHeader = @IdFileHeader
						   AND	IdFileDetail = @IdFileDetail
						   AND	IdItem = @IdItem)
				BEGIN
					IF(@IsSubstract = 0)
						BEGIN
							UPDATE	[ItemInventory]
							   SET	Stock = (@LastStock + @NewStock),
									CIFcost = @CIFCotQuetzal,
									FOcost = @FOCostQuetzal,
									CustomDuties = @CustomDuties,
									Iva = @Iva
							 WHERE	IdCustomer = @IdCustomer
							   AND	IdAccount = @IdAccount
							   AND	IdFileHeader = @IdFileHeader
							   AND	IdFileDetail = @IdFileDetail
							   AND	IdItem = @IdItem;
						END
				END
		END
	ELSE
		BEGIN
			RAISERROR (N'El documento ya se encuentra revisado, por lo tanto no se pueden realizar modificaciones.',16,1);
		END