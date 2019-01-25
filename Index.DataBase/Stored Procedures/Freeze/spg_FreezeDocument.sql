﻿CREATE PROCEDURE [dbo].[spg_FreezeDocument]
	@IdFileHeader	INT
AS
	SELECT	fd.IdFileHeader, i.Name[ItemName], fd.TransactionLine,
			ii.Quantity, 
			ii.Stock, ISNULL(ii.Freeze, 0)[Discharge], 
			(ii.Stock + ISNULL(Freeze, 0)) - ISNULL(Freeze, 0)[Balance],
			CASE WHEN ii.Freeze IS NULL
				THEN CONVERT(BIT, 0)
				ELSE CONVERT(BIT, 1)
			END[IsFrozen]
	  FROM	FileDetail fd INNER JOIN Item i ON i.Id = fd.IdItem
						  INNER JOIN ItemInventory ii ON ii.IdFileDetail = fd.Id
	 WHERE	fd.IdFileHeader = @IdFileHeader;