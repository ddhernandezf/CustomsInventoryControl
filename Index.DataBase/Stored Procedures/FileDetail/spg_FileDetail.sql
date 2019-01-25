CREATE PROCEDURE [spg_FileDetail]
	@IdFileHeader	INT
AS
	DECLARE @TempFileDetail TABLE (
		[Id] INT NOT NULL,
		[IdFileHeader] INT NOT NULL,
		[IdState] INT NOT NULL,
		[TransactionLine] INT NULL,
		[IdItem] INT NOT NULL,
		[ItemQuantity] DECIMAL(18,6) NULL,
		[CIFCotQuetzal] DECIMAL(18,6) NULL,
		[FOCostQuetzal] DECIMAL(18,6) NULL,
		[CIFCotDollar] DECIMAL(18,6) NULL,
		[FOCostDollar] DECIMAL(18,6) NULL,
		[CustomDuties] DECIMAL(18,6) NULL,
		[Iva] DECIMAL(18,6) NULL,
		[TaxableBase] DECIMAL(18,6) NULL,
		[TaxRate] DECIMAL(18,6) NULL,
		[NetWeight] DECIMAL(18,6) NULL,
		[GrossWeight] DECIMAL(18,6) NULL
	)

	INSERT INTO @TempFileDetail(Id, IdFileHeader, IdState, TransactionLine, IdItem, ItemQuantity, CIFCotQuetzal, FOCostQuetzal, CIFCotDollar, 
								FOCostDollar, CustomDuties, Iva, TaxableBase, TaxRate, NetWeight, GrossWeight)
	SELECT	Id, IdFileHeader, IdState, TransactionLine, IdItem, ItemQuantity, CIFCotQuetzal, FOCostQuetzal, CIFCotDollar, 
			FOCostDollar, CustomDuties, Iva, TaxableBase, TaxRate, NetWeight, GrossWeight
	  FROM	[FileDetail]
	 WHERE	IdFileHeader = @IdFileHeader

	SELECT	fd.Id[IdFileDetail], fd.IdFileHeader, fd.IdState, s.[Name][StateName], fd.TransactionLine,  fd.IdItem, 
			CONCAT(i.[Name], ' (', um.Symbol, ')') [ItemName], 
			fd.ItemQuantity, fd.CIFCotQuetzal, fd.FOCostQuetzal, fd.CIFCotDollar, fd.FOCostDollar, fd.CustomDuties, fd.Iva, 
			fd.TaxableBase, fd.TaxRate, fd.NetWeight, fd.GrossWeight, ai.AccountingItem,
			CONCAT(i.Code, ' - ', i.Name, ' (', um.Symbol, ')')[DisplayItemName],
			CONCAT(ai.AccountingItem, ' - ' , ai.Description)[DisplayAccountingItem],
			CASE WHEN ii.Freeze IS NULL
				THEN CONVERT(BIT, 0)
				ELSE CONVERT(BIT, 1)
			END[IsFrozen]
	  FROM	@TempFileDetail fd INNER JOIN [State] s ON s.Id = fd.IdState
							   INNER JOIN [Item] i ON i.Id = fd.IdItem
							   INNER JOIN [UnitMeasurement] um ON um.Id = i.IdUnitMeasurement
							   LEFT OUTER JOIN [AccountingItem] ai ON ai.Id = i.IdAccountingItem
							   LEFT OUTER JOIN [ItemInventory] ii ON ii.IdFileDetail = fd.Id
	 WHERE	fd.IdFileHeader = @IdFileHeader
	 ORDER BY fd.Id desc