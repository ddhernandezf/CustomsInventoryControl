DECLARE	@IdDocument			VARCHAR(100) = '274-6504893',
		@Transactionline	INT = 1,
		@Stardate			DATE = '2017-06-01',
		@enddate			DATE = '2017-06-13',
		@IdFileDetail		INT,
		@OriginalQuantity	DECIMAL(18,6),
		@Stock				DECIMAL(18,6),
		@DischargePast		DECIMAL(18,6),
		@Discharge			DECIMAL(18,6),
		@Balance			DECIMAL(18,6),
		@StockCalc			DECIMAL(18,6),
		@Transmited			BIT = 1;

SELECT	@IdFileDetail = fd.Id, @OriginalQuantity = FD.ItemQuantity, @Stock = II.Stock
  FROM	FileDetail fd INNER JOIN FileHeader fh ON fd.IdFileHeader = fh.Id
					  INNER JOIN ItemInventory ii ON ii.IdFileDetail = fd.Id
												  AND ii.IdFileHeader = fh.Id
												  AND ii.IdItem = fd.IdItem
 WHERE	fh.IdDocument = @IdDocument
   AND	fd.TransactionLine = @Transactionline;

SELECT	fh.IdDocument, ii.Stock, fd.*
  FROM	FileDetail fd INNER JOIN FileHeader fh ON fd.IdFileHeader = fh.Id
					  INNER JOIN ItemInventory ii ON ii.IdFileDetail = fd.Id
												  AND ii.IdFileHeader = fh.Id
												  AND ii.IdItem = fd.IdItem
 WHERE	fh.IdDocument = @IdDocument
   AND	fd.TransactionLine = @Transactionline;

SELECT 'MOVIMIENTOS ANTERIORES';

SELECT	@DischargePast = SUM(Quantity + Decrease)
  FROM	FileItemDischarge fid
 WHERE	fid.IdFileDetailStock = @IdFileDetail 
   AND	CONVERT(DATE, fid.RegisterDate) < @Stardate

SELECT	fh.IdDocument, i.Name[ItemName], fid.* 
  FROM	FileItemDischarge fid INNER JOIN FileDetail fd ON fid.IdFileDetailSubstract = fd.Id
							  INNER JOIN FileHeader fh ON fd.IdFileHeader = fh.Id
							  INNER JOIN Item i ON i.Id = fd.IdItem
 WHERE	fid.IdFileDetailStock = @IdFileDetail 
   AND	CONVERT(DATE, fid.RegisterDate) < @Stardate
 ORDER	BY fid.RegisterDate ASC

SELECT 'MOVIMIENTOS EN RAGO DE FECHAS';

IF(@Transmited IS NULL)
	BEGIN
		SELECT	@Discharge = SUM(Quantity + Decrease)
		  FROM	FileItemDischarge fid
		 WHERE	fid.IdFileDetailStock = @IdFileDetail 
		   AND	CONVERT(DATE, fid.RegisterDate) BETWEEN @Stardate AND @enddate;

		SELECT	fh.IdDocument, i.Name[ItemName], fid.* 
		  FROM	FileItemDischarge fid INNER JOIN FileDetail fd ON fid.IdFileDetailSubstract = fd.Id
									  INNER JOIN FileHeader fh ON fd.IdFileHeader = fh.Id
									  INNER JOIN Item i ON i.Id = fd.IdItem
		 WHERE	fid.IdFileDetailStock = @IdFileDetail 
		   AND	CONVERT(DATE, fid.RegisterDate) BETWEEN @Stardate AND @enddate
		 ORDER	BY fid.RegisterDate ASC;
	END
ELSE IF (@Transmited = 1)
	BEGIN
		SELECT	@Discharge = SUM(Quantity + Decrease)
		  FROM	FileItemDischarge fid
		 WHERE	fid.IdFileDetailStock = @IdFileDetail 
		   AND	CONVERT(DATE, fid.RegisterDate) BETWEEN @Stardate AND @enddate
		   AND	fid.IdState = (SELECT Id FROM [State] WHERE Name = 'Transmitido');

		SELECT	fh.IdDocument, i.Name[ItemName], fid.* 
		  FROM	FileItemDischarge fid INNER JOIN FileDetail fd ON fid.IdFileDetailSubstract = fd.Id
									  INNER JOIN FileHeader fh ON fd.IdFileHeader = fh.Id
									  INNER JOIN Item i ON i.Id = fd.IdItem
		 WHERE	fid.IdFileDetailStock = @IdFileDetail 
		   AND	CONVERT(DATE, fid.RegisterDate) BETWEEN @Stardate AND @enddate
		   AND	fid.IdState = (SELECT Id FROM [State] WHERE Name = 'Transmitido')
		 ORDER	BY fid.RegisterDate ASC;
	END
ELSE IF (@Transmited = 0)
	BEGIN
		SELECT	@Discharge = SUM(Quantity + Decrease)
		  FROM	FileItemDischarge fid
		 WHERE	fid.IdFileDetailStock = @IdFileDetail 
		   AND	CONVERT(DATE, fid.RegisterDate) BETWEEN @Stardate AND @enddate
		   AND	fid.IdState <> (SELECT Id FROM [State] WHERE Name = 'Transmitido');

		SELECT	fh.IdDocument, i.Name[ItemName], fid.* 
		  FROM	FileItemDischarge fid INNER JOIN FileDetail fd ON fid.IdFileDetailSubstract = fd.Id
									  INNER JOIN FileHeader fh ON fd.IdFileHeader = fh.Id
									  INNER JOIN Item i ON i.Id = fd.IdItem
		 WHERE	fid.IdFileDetailStock = @IdFileDetail 
		   AND	CONVERT(DATE, fid.RegisterDate) BETWEEN @Stardate AND @enddate
		   AND	fid.IdState <> (SELECT Id FROM [State] WHERE Name = 'Transmitido')
		 ORDER	BY fid.RegisterDate ASC;
	END

SELECT 'TOTALES'

SET @Balance = (@OriginalQuantity - @DischargePast);
SET @StockCalc = (@Balance - @Discharge);
SELECT @Stock[Stock], @OriginalQuantity[QuantityDoc], @DischargePast[DischargePast],@Balance[Balance], @Discharge[Discharge], @StockCalc[StockCalc]