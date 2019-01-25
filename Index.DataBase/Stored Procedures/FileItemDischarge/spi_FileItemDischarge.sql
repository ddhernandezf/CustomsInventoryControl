CREATE PROCEDURE [dbo].[spi_FileItemDischarge]
	@IdFileDetailSubstract	INT,
	@IdFileDetailStock		INT,
	@Quantity				DECIMAL(18,6),
	@Decrease				DECIMAL(18,6),
	@UseFormula				BIT,
	@RegisterUser			VARCHAR(60)
AS
	DECLARE	@OriginalStock	DECIMAL(18,6),
			@Stock			DECIMAL(18,6),
			@CifTotal		DECIMAL(18,6),
			@FobTotal		DECIMAL(18,6),
			@DutieTotal		DECIMAL(18,6),
			@IvaTotal		DECIMAL(18,6),
			@CifTotal_ii	DECIMAL(18,6),
			@FobTotal_ii	DECIMAL(18,6),
			@DutieTotal_ii	DECIMAL(18,6),
			@IvaTotal_ii	DECIMAL(18,6),
			@Cif			DECIMAL(18,6),
			@Fob			DECIMAL(18,6),
			@Dutie			DECIMAL(18,6),
			@Iva			DECIMAL(18,6),
			@DischargeTotal	DECIMAL(18,6),
			@Percent		DECIMAL(12,6),
			@QuanFormTotal	DECIMAL(18,6) = 0,
			@DecrFormTotal	DECIMAL(18,6) = 0,
			@QuanFormCurre	DECIMAL(18,6) = 0,
			@DecrFormCurre	DECIMAL(18,6) = 0,
			@FormQuantity	DECIMAL(18,6) = 0,
			@IdItemSubs		INT,
			@IdItemStock	INT,
			@Pass			BIT = 0,
			@MSG			VARCHAR(150) = '',
			@PercentError	BIT = 0;

	SELECT	@OriginalStock = fd.ItemQuantity, @CifTotal = fd.CIFCotQuetzal, @FobTotal = fd.FOCostQuetzal, 
			@DutieTotal = fd.CustomDuties, @IvaTotal = fd.Iva, @Stock = ii.Stock, @CifTotal_ii = ii.CIFcost, 
			@FobTotal_ii = ii.FOcost, @DutieTotal_ii = ii.CustomDuties, @IvaTotal_ii = ii.Iva
	  FROM	FileDetail fd INNER JOIN ItemInventory ii ON ii.IdFileDetail = fd.Id
			AND ii.IdItem = fd.IdItem
	 WHERE	Id = @IdFileDetailStock

	SET @Decrease = ISNULL(@Decrease, 0);
	SET @DischargeTotal = (@Quantity + @Decrease);

	IF(@DischargeTotal <= @Stock)
		BEGIN
			IF(@DischargeTotal = @Stock)
				BEGIN
					SET @Cif = @CifTotal_ii;
					SET @Fob = @FobTotal_ii;
					SET @Dutie = @DutieTotal_ii;
					SET @Iva = @IvaTotal_ii;
				END
			ELSE
				BEGIN
					SET @Percent = (@DischargeTotal / @OriginalStock);
					SET @Cif = (@CifTotal * @Percent);
					SET @Fob = (@FobTotal * @Percent);
					SET @Dutie = (@DutieTotal * @Percent);
					SET @Iva = (@IvaTotal * @Percent);

					IF(@Percent = 0)
						BEGIN
							SET @PercentError = 1;
						END

				END

			IF(@PercentError = 1)
				BEGIN
					RAISERROR (N'La cantidad a descargar es muy pequeña en relación con los montos manejados para esta materia prima. Favor de comunicarse con el fabricante.',16,1);
				END
			ELSE
				BEGIN
					IF(ISNULL(@UseFormula, 0) = 1)
					BEGIN
						--SELECT @IdItemSubs = IdItem FROM FileDetail WHERE Id = @IdFileDetailSubstract;
						--SELECT @IdItemStock = IdItem, @FormQuantity = ItemQuantity FROM FileDetail WHERE Id = @IdFileDetailStock;
						SELECT @IdItemSubs = IdItem, @FormQuantity = ItemQuantity FROM FileDetail WHERE Id = @IdFileDetailSubstract;
						SELECT @IdItemStock = IdItem FROM FileDetail WHERE Id = @IdFileDetailStock;
			
						SELECT	@QuanFormCurre = ISNULL(SUM(Quantity), 0), @DecrFormCurre = ISNULL(SUM(Decrease), 0)
						  FROM	FileItemDischarge
						 WHERE	IdFileDetailSubstract = @IdFileDetailSubstract
							AND Exists(SELECT 1
										FROM FileDetail TS1
										WHERE TS1.Id = FileItemDischarge.IdFileDetailStock
											AND TS1.IdItem = @IdItemStock)

						SELECT	@QuanFormTotal = (@FormQuantity * f.Quantity), @DecrFormTotal = (@FormQuantity * f.Decrease)
						  FROM	Formula f
						 WHERE	f.IdMainItem = @IdItemSubs AND IdDetailItem = @IdItemStock

						SET	@QuanFormCurre = @QuanFormCurre + @Quantity;
						SET	@DecrFormCurre = @DecrFormCurre + @Decrease;
					END

				IF(@QuanFormTotal = 0 AND @DecrFormTotal = 0 AND @QuanFormCurre = 0 AND @DecrFormCurre = 0)
					BEGIN
						SET	@Pass = 1;
					END
				ELSE
					BEGIN
						IF((@QuanFormCurre <= @QuanFormTotal) AND (@DecrFormCurre <= @DecrFormTotal))
							BEGIN
							
								--if(@Quantity = 0 or @Decrease = 0)
								--	BEGIN
								--		SET	@MSG = 'No se puede contener valores en cero dentro del registro.';
								--	END
								--ELSE
								--	BEGIN
								--		SET	@Pass = 1;
								--	END
								SET	@Pass = 1;
							END
						ELSE
							BEGIN
								SET	@MSG = 'Las cantidades superan los límites de la formula';
							END
					END

				IF(@Pass = 0)
					BEGIN
						RAISERROR (@MSG,16,1);
					END
				ELSE
					BEGIN
						INSERT INTO FileItemDischarge(IdFileDetailSubstract, IdFileDetailStock, IdState,Quantity, Decrease, CIFcost, FOcost,
														CustomDuties, Iva, RegisterDate, RegisterUser)
						VALUES(@IdFileDetailSubstract, @IdFileDetailStock, 1, @Quantity, @Decrease, @Cif, @Fob, @Dutie, @Iva, GETDATE(), @RegisterUser);

						UPDATE	ItemInventory
						   SET	Stock = (Stock - @DischargeTotal),
								CIFcost = (CIFcost - @Cif),
								FOcost = (FOcost - @Fob),
								CustomDuties = (CustomDuties - @Dutie),
								Iva = (Iva - @Iva)
						 WHERE	IdFileDetail = @IdFileDetailStock;

						DECLARE @NewCif	DECIMAL(18,6),
								@NewFob	DECIMAL(18,6),
								@NewDai	DECIMAL(18,6),
								@NewIva	DECIMAL(18,6);

						SELECT	@NewCif = SUM(CIFcost), @NewFob = SUM(FOcost), @NewDai = SUM(CustomDuties), @NewIva = SUM(Iva)
						  FROM	FileItemDischarge
						 WHERE	IdFileDetailSubstract = @IdFileDetailSubstract

						UPDATE	[FileDetail]
						   SET	CIFCotQuetzal = @NewCif,
								FOCostQuetzal = @NewFob,
								CustomDuties = @NewDai,
								Iva = @NewIva
						 WHERE	Id = @IdFileDetailSubstract;

						IF EXISTS(	SELECT	*
									  FROM	[ItemInventory]
									 WHERE	IdFileDetail = @IdFileDetailStock
									   AND	Stock = 0)
							BEGIN
								UPDATE	ItemInventory
								   SET	IdState = (SELECT Id FROM [State] WHERE Name = 'Finalizado')
								 WHERE	IdFileDetail = @IdFileDetailStock
								   AND	Stock = 0
							END
					END
				END
		END
	ELSE
		BEGIN
			RAISERROR (N'No hay existencia suficiente para aplicar el descargo en este documento.',16,1);
		END
