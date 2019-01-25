CREATE PROCEDURE [dbo].[spi_Formula]
	@IdMainItem		INT,
	@IdDetailItem	INT,
	@Quantity		DECIMAL(18,6),
	@Decrease		DECIMAL(18,6),
	@Active			BIT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Formula]
				 WHERE	IdMainItem = @IdMainItem
				   AND	IdDetailItem = @IdDetailItem))
		BEGIN
			RAISERROR (N'Esta materia prima ya se encuentra registrada en la formula para este producto.',16,1);
		END
	ELSE
		BEGIN
			INSERT INTO [Formula](IdMainItem, IdDetailItem, Quantity, Decrease, RegisterDate, RegisterUser, Active)
			VALUES(@IdMainItem, @IdDetailItem, @Quantity, @Decrease, GETDATE(), @RegisterUser, @Active);
		END
