CREATE PROCEDURE [dbo].[spg_DischargeTransactions]
	@IdFileDetail	INT,
	@IdItem			INT,
	@IdAccount		INT
AS
	DECLARE @TempItemInventory TABLE (
		[IdCustomer] INT NOT NULL,
		[IdAccount] INT NOT NULL,
		[IdFileHeader] INT NOT NULL,
		[IdFileDetail] INT NOT NULL,
		[IdItem] INT NOT NULL,
		[Quantity] DECIMAL(18,6)NOT NULL,
		[Stock] DECIMAL(18,6)NOT NULL,
		[TransactionDate] DATETIME NOT NULL,
		[IdState] INT NOT NULL
	)

	DECLARE @TempData TABLE (
		[IdCustomer] INT NOT NULL,
		[IdAccount] INT NOT NULL,
		[AccountName] VARCHAR(100) NOT NULL,
		[IdFileDetail] INT NOT NULL,
		[IdDocument] VARCHAR(100) NULL,
		[IdFileHeader] INT NOT NULL,
		[DocumentName] VARCHAR(100) NULL,
		[IdItem] INT NOT NULL,
		[Original] DECIMAL(18,6)NOT NULL,
		[Stock] DECIMAL(18,6)NOT NULL,
		[TransactionDate] DATETIME NOT NULL
	)

	DECLARE @TempFileItemDischarge TABLE (
		[Id] INT NOT NULL,
		[IdFileDetailSubstract] INT NOT NULL,
		[IdFileDetailStock] INT NOT NULL,
		[IdState] INT NOT NULL,
		[Quantity] DECIMAL(18,6) NOT NULL,
		[Decrease] DECIMAL(18,6) NOT NULL,
		[CIFcost] DECIMAL(18,6) NOT NULL,
		[FOcost] DECIMAL(18,6) NULL,
		[CustomDuties] DECIMAL(18,6) NULL,
		[Iva] DECIMAL(18,6) NOT NULL
	)

	DECLARE	@ThresholdDate  DATE = '2016-03-31',
			@SubstractDate	DATE,
			@UseExpired		BIT

	SELECT	@UseExpired = fc.UseExpired, @SubstractDate = fh.AuthorizationDate
	  FROM	[FileDetail] fd INNER JOIN [FileHeader] fh ON fh.Id = fd.IdFileHeader
							INNER JOIN [FileInfoConfig] fc ON fc.Id = fh.IdFileInfoConfig
	 WHERE	fd.Id = @IdFileDetail

	INSERT INTO @TempItemInventory (IdCustomer, IdAccount, IdFileHeader, IdFileDetail, IdItem, Quantity, Stock, TransactionDate, IdState)
	SELECT	ii.IdCustomer, ii.IdAccount, ii.IdFileHeader, ii.IdFileDetail, ii.IdItem, ii.Quantity, ii.Stock, ii.TransactionDate, ii.IdState
	  FROM	ItemInventory ii
	 WHERE	ii.IdItem = @IdItem

	DECLARE	@IdState	INT

	SELECT	@IdState = IdState
	  FROM	@TempItemInventory

	INSERT INTO @TempFileItemDischarge (Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity, 
										Decrease, CIFcost, FOcost, CustomDuties, Iva)
	SELECT	MIN(Id), IdFileDetailSubstract, IdFileDetailStock, MAX(IdState), SUM(Quantity), SUM(Decrease), SUM(CIFcost), SUM(FOcost), 
			SUM(CustomDuties), SUM(Iva)
	  FROM	[FileItemDischarge]
	 WHERE	IdFileDetailSubstract = @IdFileDetail
	 GROUP BY IdFileDetailSubstract, IdFileDetailStock
	
	IF(@UseExpired = 0)
		BEGIN
			INSERT INTO @TempData(IdCustomer, IdAccount, AccountName, IdFileDetail, IdDocument, IdFileHeader, DocumentName,
									IdItem, Original, Stock, TransactionDate)
			SELECT	ii.IdCustomer, ii.IdAccount, a.[Name][AccountName], ii.IdFileDetail,
					fh.IdDocument, ii.IdFileHeader, CONCAT(fi.[Name], ' (', ft.[Name], ')')[DocumentName],
					ii.IdItem, ii.Quantity, ii.Stock,
					CASE WHEN fh.AuthorizationDate IS NULL
						THEN ii.TransactionDate
						ELSE fh.AuthorizationDate
					END [TransactionDate]
			  FROM	@TempItemInventory ii INNER JOIN Account a ON a.Id = ii.IdAccount
										 INNER JOIN [FileHeader] fh ON fh.Id = ii.IdFileHeader
										 INNER JOIN [FileInfoConfig] fc ON fc.Id = fh.IdFileInfoConfig
										 INNER JOIN [FileInfo] fi ON fi.Id = fc.IdFileInfo
										 INNER JOIN [FileInfoType] ft ON ft.Id = fc.IdFileType
			 WHERE	CONVERT(DATE, fh.AuthorizationDate) <= @SubstractDate
			   AND (CASE WHEN (CONVERT(DATE, fh.AuthorizationDate) < @ThresholdDate)  -- Valicacion agregada, quemada para polizas que no tienen ampliacion y las que si
					THEN CONVERT(DATE, dateadd(mm, 12, fh.ExpirationDate))
					ELSE CONVERT(DATE, fh.ExpirationDate) END) > CONVERT(DATE, GETDATE());
		END
	ELSE
		BEGIN
			INSERT INTO @TempData(IdCustomer, IdAccount, AccountName, IdFileDetail, IdDocument, IdFileHeader, DocumentName,
									IdItem, Original, Stock, TransactionDate)
			SELECT	ii.IdCustomer, ii.IdAccount, a.[Name][AccountName], ii.IdFileDetail,
					fh.IdDocument, ii.IdFileHeader, CONCAT(fi.[Name], ' (', ft.[Name], ')')[DocumentName],
					ii.IdItem, ii.Quantity, ii.Stock,
					CASE WHEN fh.AuthorizationDate IS NULL
						THEN ii.TransactionDate
						ELSE fh.AuthorizationDate
					END [TransactionDate]
			  FROM	@TempItemInventory ii INNER JOIN Account a ON a.Id = ii.IdAccount
										 INNER JOIN [FileHeader] fh ON fh.Id = ii.IdFileHeader
										 INNER JOIN [FileInfoConfig] fc ON fc.Id = fh.IdFileInfoConfig
										 INNER JOIN [FileInfo] fi ON fi.Id = fc.IdFileInfo
										 INNER JOIN [FileInfoType] ft ON ft.Id = fc.IdFileType
			 WHERE	CONVERT(DATE, fh.AuthorizationDate) <= @SubstractDate;
		END

	IF(@IdState = 11)
		BEGIN
			SELECT	td.IdCustomer, td.IdAccount, AccountName, IdFileDetail, td.IdDocument, td.IdFileHeader, DocumentName,
					td.IdItem, Original, Stock, TransactionDate, 
					CASE WHEN Quantity IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE Quantity
					END [Quantity], 
					CASE WHEN Decrease IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE Decrease
					END [Decrease], 
					CASE WHEN CIFcost IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE CIFcost
					END [CIFcost], 
					CASE WHEN FOcost IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE FOcost
					END [FOcost], 
					CASE WHEN fd.CustomDuties IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE fd.CustomDuties
					END [CustomDuties], 
					CASE WHEN fd.Iva IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE fd.Iva
					END [Iva],
					fd.IdState, s.Name[StateName],
					CONCAT(DocumentName, ' ', td.IdDocument)[DisplayDocument],
				CASE WHEN fh.ExpirationDate < GETDATE() 
					THEN CONVERT(BIT, 1)
					ELSE CONVERT(BIT, 0)
				END[IsExpired], 
				fdd.TransactionLine
			  FROM	@TempData td LEFT OUTER JOIN @TempFileItemDischarge fd On fd.IdFileDetailStock = td.IdFileDetail
								 LEFT OUTER JOIN [State] s ON s.Id = fd.IdState
								 INNER JOIN [FileHeader] fh ON fh.Id = td.IdFileHeader
								 INNER JOIN [FileDetail] fdd ON fdd.Id = td.IdFileDetail
			 WHERE	fd.IdState IS NOT NULL
			   AND	fh.IdAccount = @IdAccount
			 UNION
			 SELECT	td.IdCustomer, td.IdAccount, AccountName, IdFileDetail, td.IdDocument, td.IdFileHeader, DocumentName,
					td.IdItem, Original, Stock, TransactionDate, 
					CASE WHEN Quantity IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE Quantity
					END [Quantity], 
					CASE WHEN Decrease IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE Decrease
					END [Decrease], 
					CASE WHEN CIFcost IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE CIFcost
					END [CIFcost], 
					CASE WHEN FOcost IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE FOcost
					END [FOcost], 
					CASE WHEN fd.CustomDuties IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE fd.CustomDuties
					END [CustomDuties], 
					CASE WHEN fd.Iva IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE fd.Iva
					END [Iva],
					fd.IdState, s.Name[StateName],
					CONCAT(DocumentName, ' ', td.IdDocument)[DisplayDocument],
				CASE WHEN fh.ExpirationDate < GETDATE() 
					THEN CONVERT(BIT, 1)
					ELSE CONVERT(BIT, 0)
				END[IsExpired], 
				fdd.TransactionLine
			  FROM	@TempData td LEFT OUTER JOIN @TempFileItemDischarge fd On fd.IdFileDetailStock = td.IdFileDetail
								 LEFT OUTER JOIN [State] s ON s.Id = fd.IdState
								 INNER JOIN [FileHeader] fh ON fh.Id = td.IdFileHeader
								 INNER JOIN [FileDetail] fdd ON fdd.Id = td.IdFileDetail
			 WHERE	fd.IdState IS NULL
			   AND	td.Stock <> 0
			   AND	fh.IdAccount = @IdAccount
			 ORDER BY TransactionDate ASC
		END
	ELSE
		BEGIN
			SELECT	td.IdCustomer, td.IdAccount, AccountName, IdFileDetail, td.IdDocument, td.IdFileHeader, DocumentName,
					td.IdItem, Original, Stock, TransactionDate, 
					CASE WHEN Quantity IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE Quantity
					END [Quantity], 
					CASE WHEN Decrease IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE Decrease
					END [Decrease], 
					CASE WHEN CIFcost IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE CIFcost
					END [CIFcost], 
					CASE WHEN FOcost IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE FOcost
					END [FOcost], 
					CASE WHEN fd.CustomDuties IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE fd.CustomDuties
					END [CustomDuties], 
					CASE WHEN fd.Iva IS NULL
						THEN CONVERT(DECIMAL(18,6), 0)
						ELSE fd.Iva
					END [Iva],
					fd.IdState, s.Name[StateName],
					CONCAT(DocumentName, ' ', td.IdDocument)[DisplayDocument],
				CASE WHEN fh.ExpirationDate < GETDATE() 
					THEN CONVERT(BIT, 1)
					ELSE CONVERT(BIT, 0)
				END[IsExpired], 
				fdd.TransactionLine
			  FROM	@TempData td LEFT OUTER JOIN @TempFileItemDischarge fd On fd.IdFileDetailStock = td.IdFileDetail
								 LEFT OUTER JOIN [State] s ON s.Id = fd.IdState
								 INNER JOIN [FileHeader] fh ON fh.Id = td.IdFileHeader
								 INNER JOIN [FileDetail] fdd ON fdd.Id = td.IdFileDetail
			 WHERE	fd.IdState IS NOT NULL
			   AND	fh.IdAccount = @IdAccount
			 UNION
			SELECT	td.IdCustomer, td.IdAccount, AccountName, IdFileDetail, td.IdDocument, td.IdFileHeader, DocumentName,
				td.IdItem, Original, Stock, TransactionDate, 
				CASE WHEN Quantity IS NULL
					THEN CONVERT(DECIMAL(18,6), 0)
					ELSE Quantity
				END [Quantity], 
				CASE WHEN Decrease IS NULL
					THEN CONVERT(DECIMAL(18,6), 0)
					ELSE Decrease
				END [Decrease], 
				CASE WHEN CIFcost IS NULL
					THEN CONVERT(DECIMAL(18,6), 0)
					ELSE CIFcost
				END [CIFcost], 
				CASE WHEN FOcost IS NULL
					THEN CONVERT(DECIMAL(18,6), 0)
					ELSE FOcost
				END [FOcost], 
				CASE WHEN fd.CustomDuties IS NULL
					THEN CONVERT(DECIMAL(18,6), 0)
					ELSE fd.CustomDuties
				END [CustomDuties], 
				CASE WHEN fd.Iva IS NULL
					THEN CONVERT(DECIMAL(18,6), 0)
					ELSE fd.Iva
				END [Iva],
				fd.IdState, s.Name[StateName],
				CONCAT(DocumentName, ' ', td.IdDocument)[DisplayDocument],
				CASE WHEN fh.ExpirationDate < GETDATE() 
					THEN CONVERT(BIT, 1)
					ELSE CONVERT(BIT, 0)
				END[IsExpired], 
				fdd.TransactionLine
		  FROM	@TempData td LEFT OUTER JOIN @TempFileItemDischarge fd On fd.IdFileDetailStock = td.IdFileDetail
							 LEFT OUTER JOIN [State] s ON s.Id = fd.IdState
							 INNER JOIN [FileHeader] fh ON fh.Id = td.IdFileHeader
							 INNER JOIN [FileDetail] fdd ON fdd.Id = td.IdFileDetail
		 WHERE	fd.IdState IS NULL
		   AND	TD.Stock <> 0
		   AND	fh.IdAccount = @IdAccount
		 ORDER BY TransactionDate ASC
		END