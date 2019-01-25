CREATE PROCEDURE [dbo].[spu_FileItemDischarge]
	@IdFileDetailSubstract	INT,
	@IdFileDetailStock		INT,
	@Quantity				DECIMAL(18,6),
	@Decrease				DECIMAL(18,6),
	@UseFormula				BIT,
	@RegisterUser			VARCHAR(60)
AS
	EXEC spd_FileItemDischarge @IdFileDetailSubstract, @IdFileDetailStock;
	EXEC spi_FileItemDischarge @IdFileDetailSubstract, @IdFileDetailStock, @Quantity, @Decrease, @UseFormula, @RegisterUser;