CREATE PROCEDURE [dbo].[spo_FileItemDischarge]
	@IdFileDetailSubstract	INT,
	@IdFileDetailStock		INT,
	@Quantity				DECIMAL(18,6),
	@Decrease				DECIMAL(18,6),
	@UseFormula				BIT,
	@RegisterUser			VARCHAR(60)
AS
	IF EXISTS(	SELECT	*
				  FROM	FileItemDischarge
				 WHERE IdFileDetailSubstract = @IdFileDetailSubstract
				   AND	IdFileDetailStock = @IdFileDetailStock)
		BEGIN
			EXEC spu_FileItemDischarge @IdFileDetailSubstract, @IdFileDetailStock, @Quantity, @Decrease, @UseFormula, @RegisterUser;
		END
	ELSE
		BEGIN
			EXEC spi_FileItemDischarge @IdFileDetailSubstract, @IdFileDetailStock, @Quantity, @Decrease, @UseFormula, @RegisterUser;
		END