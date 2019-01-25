CREATE PROCEDURE [dbo].[spg_ItemGlobalStock]
	@IdItem	INT
AS
	SELECT	SUM(Stock)[Stock]
	  FROM	ItemInventory
	 WHERE	IdItem = @IdItem;