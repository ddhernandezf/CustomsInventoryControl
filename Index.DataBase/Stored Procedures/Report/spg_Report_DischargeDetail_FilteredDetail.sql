CREATE PROCEDURE [dbo].[spg_Report_DischargeDetail_FilteredDetail]
	@TransFlag		BIT,
	@StartDate		DATE,
	@EndDate		DATE,
	@IdCustomer		INT,
	@IdAccount		INT,
	@IdFileHeader	INT
AS

	DECLARE @DetailTemp TABLE (
		[IdFileDetailTemp]	INT NOT NULL
	)
	
	IF(@TransFlag IS NULL)
		BEGIN
			INSERT INTO @DetailTemp(IdFileDetailTemp)
			SELECT	DISTINCT fid.IdFileDetailStock
			  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
											INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
			 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
			   AND	fhi.IdCustomer = @IdCustomer
			   AND	fhi.IdAccount = @IdAccount

			INSERT INTO @DetailTemp(IdFileDetailTemp)
			SELECT	DISTINCT fid.IdFileDetailSubstract
			  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
											INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
			 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
			   AND	fhi.IdCustomer = @IdCustomer
			   AND	fhi.IdAccount = @IdAccount
		END
	ELSE
		BEGIN
			DECLARE	@IdStateTransmited	INT;
			SELECT @IdStateTransmited = Id FROM [State] WHERE [Name] = 'Transmitido';

			IF(@TransFlag = 1)
				BEGIN
					INSERT INTO @DetailTemp(IdFileDetailTemp)
					SELECT	DISTINCT fid.IdFileDetailStock
					  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
													INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
					   AND	fhi.IdCustomer = @IdCustomer
					   AND	fhi.IdAccount = @IdAccount
					   AND	fid.IdState = @IdStateTransmited

					INSERT INTO @DetailTemp(IdFileDetailTemp)
					SELECT	DISTINCT fid.IdFileDetailSubstract
					  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
													INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
					   AND	fhi.IdCustomer = @IdCustomer
					   AND	fhi.IdAccount = @IdAccount
					   AND	fid.IdState = @IdStateTransmited
				END
			ELSE IF(@TransFlag = 0)
				BEGIN
					INSERT INTO @DetailTemp(IdFileDetailTemp)
					SELECT	DISTINCT fid.IdFileDetailStock
					  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
													INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
					   AND	fhi.IdCustomer = @IdCustomer
					   AND	fhi.IdAccount = @IdAccount
					   AND	fid.IdState <> @IdStateTransmited
					   
					INSERT INTO @DetailTemp(IdFileDetailTemp)
					SELECT	DISTINCT fid.IdFileDetailSubstract
					  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
													INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
					   AND	fhi.IdCustomer = @IdCustomer
					   AND	fhi.IdAccount = @IdAccount
					   AND	fid.IdState <> @IdStateTransmited
				END
		END

	SELECT	fd.Id[IdFileDetail], fd.IdFileHeader, fd.IdState, s.[Name][StateName], fd.TransactionLine,  fd.IdItem, 
			CONCAT(i.[Name], ' (', um.Symbol, ')') [ItemName], 
			fd.ItemQuantity, fd.CIFCotQuetzal, fd.FOCostQuetzal, fd.CIFCotDollar, fd.FOCostDollar, fd.CustomDuties, fd.Iva, 
			fd.TaxableBase, fd.TaxRate, fd.NetWeight, fd.GrossWeight, ai.AccountingItem,
			CONCAT(i.Code, ' - ', i.Name, ' (', um.Symbol, ')')[DisplayItemName],
			CONCAT(ai.AccountingItem, ' - ' , ai.Description)[DisplayAccountingItem]
	  FROM	[FileDetail] fd INNER JOIN [State] s ON s.Id = fd.IdState
							INNER JOIN [Item] i ON i.Id = fd.IdItem
							INNER JOIN [UnitMeasurement] um ON um.Id = i.IdUnitMeasurement
							INNER JOIN [AccountingItem] ai ON ai.Id = i.IdAccountingItem
	 WHERE	fd.Id IN (SELECT IdFileDetailTemp FROM @DetailTemp)
	   AND	fd.IdFileHeader = @IdFileHeader