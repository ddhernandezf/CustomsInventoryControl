CREATE PROCEDURE [dbo].[spg_ItemCurrentStock]
	@IdAccount		INT,
	@IdItem	INT
AS
	DECLARE @TempFileDetail TABLE (
		[Id] INT NOT NULL,
		[IdFileHeader] INT NOT NULL,
		[IdState] INT NOT NULL,
		[TransactionLine] INT NOT NULL,
		[IdItem] INT NOT NULL,
		[ItemQuantity] INT NOT NULL,
		[CIFCotQuetzal] DECIMAL(18,6) NOT NULL,
		[FOCostQuetzal] DECIMAL(18,6) NOT NULL,
		[CIFCotDollar] DECIMAL(18,6) NOT NULL,
		[FOCostDollar] DECIMAL(18,6) NOT NULL,
		[CustomDuties] DECIMAL(18,6) NOT NULL,
		[Iva] DECIMAL(18,6) NOT NULL,
		[TaxableBase] DECIMAL(18,6) NOT NULL,
		[TaxRate] DECIMAL(18,6) NOT NULL
	)

	INSERT INTO @TempFileDetail(Id, IdFileHeader, IdState, TransactionLine, IdItem, ItemQuantity, 
							CIFCotQuetzal, FOCostQuetzal, CIFCotDollar, FOCostDollar, CustomDuties, Iva, TaxableBase, TaxRate)
	SELECT	Id, IdFileHeader, IdState, TransactionLine, IdItem, ItemQuantity, CIFCotQuetzal, FOCostQuetzal,
			CIFCotDollar, FOCostDollar, CustomDuties, Iva, TaxableBase, TaxRate
	  FROM	[FileDetail]
	 WHERE	IdItem = @IdItem

	SELECT	fd.Id[IdFileDetail], fd.IdFileHeader, fd.IdState, fd.TransactionLine, fd.IdItem, fd.ItemQuantity[OriginalQuantity],
			ii.Stock
	  FROM	@TempFileDetail fd	INNER JOIN [FileHeader] fh ON fh.Id = fd.IdFileHeader
								INNER JOIN [FileInfoConfig] fc ON fc.Id = fh.IdFileInfoConfig
								INNER JOIN [ItemInventory] ii ON ii.IdAccount = @IdAccount
														  AND ii.IdCustomer = fh.IdCustomer
														  AND ii.IdFileHeader = fh.Id
														  AND ii.IdFileDetail = fd.Id
														  and ii.IdItem = fd.IdItem

	 WHERE	fc.IsSubstract = 0
	   AND	fd.IdItem = @IdItem