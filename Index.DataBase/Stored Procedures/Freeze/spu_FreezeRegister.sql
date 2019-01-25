CREATE PROCEDURE [dbo].[spu_FreezeRegister]
	@IdFileDetail	INT,
	@Discharge		DECIMAL(18,6)
AS
	UPDATE	ItemInventory
	   SET	Stock = (Stock + ISNULL(Freeze, 0)) - @Discharge,
			Freeze = @Discharge
	 WHERE	IdFileDetail = @IdFileDetail;