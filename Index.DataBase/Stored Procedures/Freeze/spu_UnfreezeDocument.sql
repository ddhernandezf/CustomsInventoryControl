CREATE	PROCEDURE [dbo].[spu_UnfreezeDocument]
	@IdFileHeader	INT
AS
	UPDATE	ItemInventory
	   SET	Stock = (Stock + ISNULL(Freeze, 0)),
			Freeze = NULL
	 WHERE	IdFileHeader = @IdFileHeader;