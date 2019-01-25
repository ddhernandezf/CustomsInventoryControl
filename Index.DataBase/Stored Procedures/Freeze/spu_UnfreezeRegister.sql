CREATE	PROCEDURE [dbo].[spu_UnfreezeRegister]
	@IdFileDetail	INT
AS
	UPDATE	ItemInventory
	   SET	Stock = (Stock + Freeze),
			Freeze = NULL
	 WHERE	IdFileDetail = @IdFileDetail;