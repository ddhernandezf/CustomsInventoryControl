CREATE PROCEDURE [dbo].[spg_DischargeDetailResume]
	@IdFileDetail	INT
AS
	SELECT	fid.Id, fd.IdFileHeader, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fd.IdItem,
			fd.TransactionLine, CONCAT(fi.Name, ' (', fit.Name, ') ', fh.IdDocument)[DocumentName],
			ii.Quantity[InventoryQuantity], ii.Stock, fid.Quantity, fid.Decrease,
			CONCAT(i.Name, ' (', u.Symbol, ')')[ItemName], ai.AccountingItem, 
			fid.CIFcost[CIFcost], fid.CustomDuties[CustomDuties], fid.Iva[Iva], s.Name[StateName], fh.AuthorizationDate[TransactionDate]
	  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fd ON fid.IdFileDetailStock = fd.Id
									INNER JOIN [FileHeader] fh ON fh.Id = fd.IdFileHeader
									INNER JOIN [Item] i ON fd.IdItem = i.Id
									INNER JOIN [UnitMeasurement] u ON u.Id = i.IdUnitMeasurement
									INNER JOIN [AccountingItem] ai ON ai.Id = i.IdAccountingItem
									INNER JOIN [FileInfoConfig] fic ON fh.IdFileInfoConfig = fic.Id
									INNER JOIN [FileInfo] fi ON fic.IdFileInfo = fi.Id
									INNER JOIN [FileInfoType] fit ON fic.IdFileType = fit.Id
									INNER JOIN [State] s ON s.Id = fid.IdState
									INNER JOIN [ItemInventory] ii ON ii.IdFileDetail = fid.IdFileDetailStock
																	AND ii.IdFileHeader = fd.IdFileHeader
																	AND ii.IdItem = fd.IdItem
	 WHERE	IdFileDetailSubstract = @IdFileDetail;