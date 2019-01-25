CREATE PROCEDURE [dbo].[spg_ItemFormula]
	@IdItem	INT
AS
	SELECT	f.IdMainItem, i.Name[ItemName]
	  FROM	Formula f INNER JOIN Item i ON i.Id = f.IdMainItem
	 WHERE	f.IdDetailItem = @IdItem;