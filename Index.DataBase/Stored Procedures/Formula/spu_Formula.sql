CREATE PROCEDURE [dbo].[spu_Formula]
	@Id				INT,
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
				   AND	IdDetailItem = @IdDetailItem
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'Esta materia prima ya se encuentra registrada en la formula para este producto.',16,1);
		END
	ELSE
		BEGIN
			UPDATE	[Formula]
			   SET	IdMainItem = @IdMainItem,
					IdDetailItem = @IdDetailItem,
					Quantity = @Quantity,
					Decrease = @Decrease,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser,
					Active= @Active
			 WHERE	Id = @Id;
		END