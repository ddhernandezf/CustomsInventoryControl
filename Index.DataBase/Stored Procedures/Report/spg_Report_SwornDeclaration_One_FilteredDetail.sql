CREATE PROCEDURE [dbo].[spg_Report_SwornDeclaration_One_FilteredDetail]
	@TransFlag		BIT,
	@StartDate		DATE,
	@EndDate		DATE,
	@IdCustomer		INT,
	@IdAccount		INT,
	@IdFileHeader	INT
AS
	DECLARE @FileItemDischargeTemp TABLE (
		[IdItem]				INT NOT NULL,
		[IdFileDetailStock]		INT NOT NULL,
		[Quantity]				DECIMAL(18,6) NOT NULL,
		[Decrease]				DECIMAL(18,6) NOT NULL,
		[CIFcost]				DECIMAL(18,6) NOT NULL,
		[FOcost]				DECIMAL(18,6) NOT NULL,
		[CustomDuties]			DECIMAL(18,6) NOT NULL,
		[Iva]					DECIMAL(18,6) NOT NULL
	)

	IF(@TransFlag IS NULL)
		BEGIN
			INSERT INTO @FileItemDischargeTemp(IdItem, IdFileDetailStock, Quantity, Decrease, CIFcost, FOcost, CustomDuties, Iva)
			SELECT	fd.IdItem, fid.IdFileDetailStock, SUM(fid.Quantity),  SUM(fid.Decrease),  SUM(fid.CIFcost),  SUM(fid.FOcost),  
							SUM(fid.CustomDuties),  SUM(fid.Iva)
			  FROM	[FileItemDischarge] fid INNER JOIN FileDetail fd ON fd.Id = fid.IdFileDetailStock
											INNER JOIN FileHeader fh ON fh.Id = fd.IdFileHeader
			 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate AND @EndDate
			   AND	fh.IdCustomer = @IdCustomer
			   AND	fh.IdAccount = @IdAccount
			 GROUP BY fd.IdItem, fid.IdFileDetailStock
		END
	ELSE
		BEGIN
			DECLARE	@IdStateTransmited	INT;
			SELECT @IdStateTransmited = Id FROM [State] WHERE [Name] = 'Transmitido';

			IF(@TransFlag = 1)
				BEGIN
					INSERT INTO @FileItemDischargeTemp(IdItem, IdFileDetailStock, Quantity, Decrease, CIFcost, FOcost, CustomDuties, Iva)
					SELECT	fd.IdItem, fid.IdFileDetailStock, SUM(fid.Quantity),  SUM(fid.Decrease),  SUM(fid.CIFcost),  SUM(fid.FOcost),  
									SUM(fid.CustomDuties),  SUM(fid.Iva)
					  FROM	[FileItemDischarge] fid INNER JOIN FileDetail fd ON fd.Id = fid.IdFileDetailStock
													INNER JOIN FileHeader fh ON fh.Id = fd.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate AND @EndDate
					   AND	fh.IdCustomer = @IdCustomer
					   AND	fh.IdAccount = @IdAccount
					   AND	fid.IdState = @IdStateTransmited
					 GROUP BY fd.IdItem, fid.IdFileDetailStock
				END
			ELSE IF(@TransFlag = 0)
				BEGIN
					INSERT INTO @FileItemDischargeTemp(IdItem, IdFileDetailStock, Quantity, Decrease, CIFcost, FOcost, CustomDuties, Iva)
					SELECT	fd.IdItem, fid.IdFileDetailStock, SUM(fid.Quantity),  SUM(fid.Decrease),  SUM(fid.CIFcost),  SUM(fid.FOcost),  
									SUM(fid.CustomDuties),  SUM(fid.Iva)
					  FROM	[FileItemDischarge] fid INNER JOIN FileDetail fd ON fd.Id = fid.IdFileDetailStock
													INNER JOIN FileHeader fh ON fh.Id = fd.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate AND @EndDate
					   AND	fh.IdCustomer = @IdCustomer
					   AND	fh.IdAccount = @IdAccount
					   AND	fid.IdState <> @IdStateTransmited
					 GROUP BY fd.IdItem, fid.IdFileDetailStock
				END
		END

	SELECT	fd.Id[IdFileDetail], fd.IdFileHeader, fd.IdState, s.[Name][StateName], fd.TransactionLine,  fd.IdItem, 
			CONCAT(i.[Name], ' (', um.Symbol, ')') [ItemName], 
			fd.ItemQuantity, fd.CIFCotQuetzal, fd.FOCostQuetzal, fd.CIFCotDollar, fd.FOCostDollar, fd.CustomDuties, fd.Iva, 
			fd.TaxableBase, fd.TaxRate, fd.NetWeight, fd.GrossWeight, ai.AccountingItem,
			CONCAT(i.Code, ' - ', i.Name, ' (', um.Symbol, ')')[DisplayItemName],
			CONCAT(ai.AccountingItem, ' - ' , ai.Description)[DisplayAccountingItem]
	  FROM	FileDetail fd	INNER JOIN [State] s ON s.Id = fd.IdState
							INNER JOIN [Item] i ON i.Id = fd.IdItem
							INNER JOIN [UnitMeasurement] um ON um.Id = i.IdUnitMeasurement
							INNER JOIN [AccountingItem] ai ON ai.Id = i.IdAccountingItem
	 WHERE	fd.Id in (	SELECT	DISTINCT ii.IdFileDetail
						  FROM	ItemInventory ii LEFT OUTER JOIN @FileItemDischargeTemp fid ON ii.IdFileDetail = fid.IdFileDetailStock
												 INNER JOIN FileHeader fh ON fh.Id = ii.IdFileHeader
						 WHERE	ii.IdCustomer = @IdCustomer
						   AND	ii.IdAccount = @IdAccount
						   AND	CONVERT(DATE, fh.AuthorizationDate) <= @EndDate
						   AND	ii.IdFileHeader = @IdFileHeader)