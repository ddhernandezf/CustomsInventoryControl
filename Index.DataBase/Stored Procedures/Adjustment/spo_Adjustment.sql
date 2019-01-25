CREATE PROCEDURE [dbo].[spo_Adjustment]
	@IdFileItemDischarge	INT,
	@IdFileDetailSubstract	INT,
	@IdFileDetailStock		INT,
	@Quantity				DECIMAL(18,6),
	@Decrease				DECIMAL(18,6),
	@UseFormula				BIT,
	@RegisterUser			VARCHAR(60)
AS
	IF(ISNULL(@IdFileItemDischarge, 0) = 0)
		BEGIN
			EXEC spi_FileItemDischarge @IdFileDetailSubstract, @IdFileDetailStock, @Quantity, @Decrease, @UseFormula, @RegisterUser;
		END
	ELSE
		BEGIN
			IF EXISTS(	SELECT	*
				  FROM	FileItemDischarge
				 WHERE	Id = @IdFileItemDischarge)
				BEGIN
					EXEC spu_Adjustment @IdFileItemDischarge, @IdFileDetailSubstract, @IdFileDetailStock, @Quantity, @Decrease, @UseFormula, @RegisterUser;
				END
			ELSE
				BEGIN
					RAISERROR (N'El sistema no logra encontrar el código interno de la transacción. Porfavor comuníquese con el fabricante.',16,1);
				END
		END