CREATE PROCEDURE [dbo].[spu_FreezeDocument]
	@IdFileHeader	INT
AS
	UPDATE	ItemInventory
	   SET	Freeze = Stock,
			Stock = (Stock-Stock)
	 WHERE	IdFileHeader = @IdFileHeader
	   AND	Stock > 0;