CREATE PROCEDURE [dbo].[spi_FileDetail]
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
			@IdFileInfoConfig	INT,
			@TriggerErrDualItem	BIT	= 0;

	SELECT	@State = UPPER(s.Name), @IsSubstract = fc.IsSubstract, @LoadRawMaterial = fc.LoadRawMaterial, @IdCustomer = f.IdCustomer,
			@IdAccount = f.IdAccount, @IdFileInfoConfig = F.IdFileInfoConfig
	  FROM	[FileHeader] f INNER JOIN [State] s ON s.Id = f.IdState
						   INNER JOIN [FileInfoConfig] fc on f.IdFileInfoConfig = fc.Id
	 WHERE	f.Id = @IdFileHeader
	
	IF(@IsSubstract = 1)
		BEGIN
			IF EXISTS(	SELECT	*
						  FROM	FileDetail 
						 WHERE	IdFileHeader = @IdFileHeader
						   AND	IdItem = @IdItem)
				BEGIN
					SET	@TriggerErrDualItem = 1;
				END
		END

	IF(@TriggerErrDualItem = 1)
		BEGIN
			RAISERROR (N'Este producto ya se encuentra registrado para este documento.',16,1);
		END
	ELSE
		BEGIN
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
					DECLARE	@IdStateIngresado	INT,
							@IdStateGrabado		INT,
							@IdFileDetail		INT,
							@LinesHeader		INT,
							@LinesDetail		INT
			
					SELECT @IdStateIngresado = Id FROM [State] WHERE [Name] = 'Ingresado'
					SELECT @IdStateGrabado = Id FROM [State] WHERE [Name] = 'Grabado'
					SELECT @LinesHeader = ISNULL(LinesTotal, 0) FROM FileHeader WHERE Id = @IdFileHeader

					IF EXISTS(	SELECT	*
								  FROM [FileHeader] fh INNER JOIN [State] s ON s.Id = fh.IdState
								 WHERE	fh.id = @IdFileHeader
								   AND	s.[Name] = 'Ingresado')
						BEGIN
							UPDATE [FileHeader] SET IdState = @IdStateGrabado WHERE Id = @IdFileHeader
						END

					IF(@LinesHeader = 0)
						BEGIN
							INSERT INTO [FileDetail] (IdFileHeader, IdState, TransactionLine, IdItem, ItemQuantity,
														CIFCotQuetzal, FOCostQuetzal, CIFCotDollar, FOCostDollar,
														CustomDuties, Iva, TaxableBase, TaxRate, NetWeight, GrossWeight, 
														RegisterDate, RegisterUser)
							VALUES(@IdFileHeader, @IdStateGrabado, @TranLine, @IdItem, @ItemQuantity,
									@CIFCotQuetzal, @FOCostQuetzal, @CIFCotDollar, @FOCostDollar,
									@CustomDuties, @Iva, @TaxableBase, @TaxRate, @NetWeight, @GrossWeight,
									GETDATE(), @RegisterUser);

							SET	@IdFileDetail = SCOPE_IDENTITY();

							IF NOT EXISTS(	SELECT	*
											  FROM	[ItemInventory]
											 WHERE	IdCustomer = @IdCustomer
											   AND	IdAccount = @IdAccount
											   AND	IdFileHeader = @IdFileHeader
											   AND	IdFileDetail = @IdFileDetail
											   AND	IdItem = @IdItem)
								BEGIN
									IF(@IsSubstract = 0)
										BEGIN
											INSERT INTO [ItemInventory](IdCustomer, IdAccount, IdFileHeader, IdFileDetail, IdItem, Quantity,
																		Stock, CIFcost, FOcost, CustomDuties, Iva, TransactionDate, IdState) 
											VALUES(@IdCustomer, @IdAccount, @IdFileHeader, @IdFileDetail, @IdItem, @ItemQuantity, @ItemQuantity, 
													@CIFCotQuetzal, @FOCostQuetzal, @CustomDuties, @Iva, GETDATE(), 1);
										END
								END
						END
					ELSE
						BEGIN
							SELECT @LinesDetail = COUNT(*) FROM FileDetail WHERE IdFileHeader = @IdFileHeader
							IF(@LinesDetail= @LinesHeader)
								BEGIN
									RAISERROR (N'Llego al límite de líneas del documento.',16,1);
								END
							ELSE
								BEGIN
									INSERT INTO [FileDetail] (IdFileHeader, IdState, TransactionLine, IdItem, ItemQuantity,
																CIFCotQuetzal, FOCostQuetzal, CIFCotDollar, FOCostDollar,
																CustomDuties, Iva, TaxableBase, TaxRate, NetWeight, GrossWeight, 
																RegisterDate, RegisterUser)
									VALUES(@IdFileHeader, @IdStateGrabado, @TranLine, @IdItem, @ItemQuantity,
											@CIFCotQuetzal, @FOCostQuetzal, @CIFCotDollar, @FOCostDollar,
											@CustomDuties, @Iva, @TaxableBase, @TaxRate, @NetWeight, @GrossWeight,
											GETDATE(), @RegisterUser);

									SET	@IdFileDetail = SCOPE_IDENTITY();

									IF NOT EXISTS(	SELECT	*
													  FROM	[ItemInventory]
													 WHERE	IdCustomer = @IdCustomer
													   AND	IdAccount = @IdAccount
													   AND	IdFileHeader = @IdFileHeader
													   AND	IdFileDetail = @IdFileDetail
													   AND	IdItem = @IdItem)
										BEGIN
											IF(@IsSubstract = 0)
												BEGIN
													INSERT INTO [ItemInventory](IdCustomer, IdAccount, IdFileHeader, IdFileDetail, IdItem, Quantity,
																				Stock, CIFcost, FOcost, CustomDuties, Iva, TransactionDate, IdState) 
													VALUES(@IdCustomer, @IdAccount, @IdFileHeader, @IdFileDetail, @IdItem, @ItemQuantity, @ItemQuantity, 
															@CIFCotQuetzal, @FOCostQuetzal, @CustomDuties, @Iva, GETDATE(), 1);
												END
										END
								END
						END
				END
			ELSE
				BEGIN
					RAISERROR (N'El documento ya se encuentra revisado, por lo tanto no se pueden realizar modificaciones.',16,1);
				END
		END