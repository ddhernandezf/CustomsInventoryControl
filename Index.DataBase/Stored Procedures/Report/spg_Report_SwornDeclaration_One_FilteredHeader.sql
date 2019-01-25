CREATE PROCEDURE [dbo].[spg_Report_SwornDeclaration_One_FilteredHeader]
	@TransFlag	BIT,
	@StartDate	DATE,
	@EndDate	DATE,
	@IdCustomer	INT,
	@IdAccount	INT, 
	@IdDocument	VARCHAR(100)
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
					 GROUP BY fd.IdItem, fid.IdFileDetailStock;
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
							 GROUP BY fd.IdItem, fid.IdFileDetailStock;
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
							 GROUP BY fd.IdItem, fid.IdFileDetailStock;
				END
		END

	IF (ISNULL(@IdDocument, '') = '')
		BEGIN
			SELECT	fh.Id, fh.IdCustomer, fh.IdFileInfoConfig, CONCAT(fi.[Name], ' (', fit.[Name], ')')[FileInfoName],
					fh.AuthorizationDate, fh.ExpantionDate, fh.ExpirationDate, fh.DocumentDate, 
					CASE WHEN fic.IsSubstract = 1 
										THEN '(-)'
										ELSE '(+)'
									END[Operation], fic.LoadRawMaterial, fic.IsSubstract, fh.IdDocument, fh.ArrivalDate, fh.ExchangeRate, 
					CASE	WHEN fh.ExchangeRate IS NULL AND fh.Insurance IS NULL THEN NULL
							WHEN fh.ExchangeRate IS NULL AND fh.Insurance IS NOT NULL THEN fh.Insurance
							WHEN fh.ExchangeRate IS NOT NULL AND fh.Insurance IS NULL THEN NULL
							WHEN fh.ExchangeRate IS NOT NULL AND fh.Insurance IS NOT NULL THEN 
							CASE WHEN fh.ExchangeRate = 0
								THEN
									fh.Insurance 
								ELSE
									(CONVERT(DECIMAL(18,6), (fh.Insurance/fh.ExchangeRate)))
							END
					END[Insurance],
					CASE	WHEN fh.ExchangeRate IS NULL AND fh.Cargo IS NULL THEN NULL
							WHEN fh.ExchangeRate IS NULL AND fh.Cargo IS NOT NULL THEN fh.Insurance
							WHEN fh.ExchangeRate IS NOT NULL AND fh.Cargo IS NULL THEN NULL
							WHEN fh.ExchangeRate IS NOT NULL AND fh.Cargo IS NOT NULL THEN 
							CASE WHEN fh.ExchangeRate = 0
								THEN
									fh.Cargo 
								ELSE
									(CONVERT(DECIMAL(18,6), (fh.Cargo/fh.ExchangeRate)))
							END
					END[Cargo], 
					fh.IdCustom, cm.[Name][CustomName],
					fh.IdCountry, c.[Name][CountryName], fh.IdWarranty, w.[Name][WarrantyName],
					fh.IdCellar, CL.[Name][CellarName], fh.IdState, st.[Name][StateName],
					fh.IdCurrency, cr.[Name][CurrencyName], fh.IdResolution, r.[Name][ResolutionName],
					fh.IdAccount, a.[Name][AccountName], fh.Reviewed, fh.CIFTotal, fh.LinesTotal, fh.RegisterDate,
					fh.RegisterUser, fh.CreateDate, fh.UpdateDate, fic.UseAttached
			  FROM	FileHeader fh	INNER JOIN FileInfoConfig fic ON fic.Id = fh.IdFileInfoConfig
									INNER JOIN FileInfoType fit ON fit.Id = fic.IdFileType
									INNER JOIN FileInfo fi ON fi.Id = fic.IdFileInfo
									LEFT OUTER JOIN Customs cm ON cm.Id = fh.IdCustom
									LEFT OUTER JOIN Country c ON c.Id = fh.IdCountry
									LEFT OUTER JOIN Cellar cl ON cl.Id = fh.IdCellar
									LEFT OUTER JOIN Warranty w ON w.Id = fh.IdWarranty
									INNER JOIN [State] st ON st.Id = fh.IdState
									LEFT OUTER JOIN Currency cr ON cr.Id = fh.IdCurrency
									INNER JOIN Account a ON a.Id = fh.IdAccount
									LEFT OUTER JOIN Resolution r ON r.Id = fh.IdResolution
			 WHERE	fh.Id IN (	SELECT	DISTINCT ii.IdFileHeader
							  FROM	ItemInventory ii LEFT OUTER JOIN @FileItemDischargeTemp fid ON ii.IdFileDetail = fid.IdFileDetailStock
													 INNER JOIN FileHeader fh ON fh.Id = ii.IdFileHeader
							 WHERE	ii.IdCustomer = @IdCustomer
							   AND	ii.IdAccount = @IdAccount
							   AND	CONVERT(DATE, fh.AuthorizationDate) <= @EndDate)
		END
	ELSE
		BEGIN
			SELECT	fh.Id, fh.IdCustomer, fh.IdFileInfoConfig, CONCAT(fi.[Name], ' (', fit.[Name], ')')[FileInfoName],
					fh.AuthorizationDate, fh.ExpantionDate, fh.ExpirationDate, fh.DocumentDate, 
					CASE WHEN fic.IsSubstract = 1 
										THEN '(-)'
										ELSE '(+)'
									END[Operation], fic.LoadRawMaterial, fic.IsSubstract, fh.IdDocument, fh.ArrivalDate, fh.ExchangeRate, 
					CASE	WHEN fh.ExchangeRate IS NULL AND fh.Insurance IS NULL THEN NULL
							WHEN fh.ExchangeRate IS NULL AND fh.Insurance IS NOT NULL THEN fh.Insurance
							WHEN fh.ExchangeRate IS NOT NULL AND fh.Insurance IS NULL THEN NULL
							WHEN fh.ExchangeRate IS NOT NULL AND fh.Insurance IS NOT NULL THEN 
							CASE WHEN fh.ExchangeRate = 0
								THEN
									fh.Insurance 
								ELSE
									(CONVERT(DECIMAL(18,6), (fh.Insurance/fh.ExchangeRate)))
							END
					END[Insurance],
					CASE	WHEN fh.ExchangeRate IS NULL AND fh.Cargo IS NULL THEN NULL
							WHEN fh.ExchangeRate IS NULL AND fh.Cargo IS NOT NULL THEN fh.Insurance
							WHEN fh.ExchangeRate IS NOT NULL AND fh.Cargo IS NULL THEN NULL
							WHEN fh.ExchangeRate IS NOT NULL AND fh.Cargo IS NOT NULL THEN 
							CASE WHEN fh.ExchangeRate = 0
								THEN
									fh.Cargo 
								ELSE
									(CONVERT(DECIMAL(18,6), (fh.Cargo/fh.ExchangeRate)))
							END
					END[Cargo], 
					fh.IdCustom, cm.[Name][CustomName],
					fh.IdCountry, c.[Name][CountryName], fh.IdWarranty, w.[Name][WarrantyName],
					fh.IdCellar, CL.[Name][CellarName], fh.IdState, st.[Name][StateName],
					fh.IdCurrency, cr.[Name][CurrencyName], fh.IdResolution, r.[Name][ResolutionName],
					fh.IdAccount, a.[Name][AccountName], fh.Reviewed, fh.CIFTotal, fh.LinesTotal, fh.RegisterDate,
					fh.RegisterUser, fh.CreateDate, fh.UpdateDate, fic.UseAttached
			  FROM	FileHeader fh	INNER JOIN FileInfoConfig fic ON fic.Id = fh.IdFileInfoConfig
									INNER JOIN FileInfoType fit ON fit.Id = fic.IdFileType
									INNER JOIN FileInfo fi ON fi.Id = fic.IdFileInfo
									LEFT OUTER JOIN Customs cm ON cm.Id = fh.IdCustom
									LEFT OUTER JOIN Country c ON c.Id = fh.IdCountry
									LEFT OUTER JOIN Cellar cl ON cl.Id = fh.IdCellar
									LEFT OUTER JOIN Warranty w ON w.Id = fh.IdWarranty
									INNER JOIN [State] st ON st.Id = fh.IdState
									LEFT OUTER JOIN Currency cr ON cr.Id = fh.IdCurrency
									INNER JOIN Account a ON a.Id = fh.IdAccount
									LEFT OUTER JOIN Resolution r ON r.Id = fh.IdResolution
			 WHERE	fh.Id IN (	SELECT	DISTINCT ii.IdFileHeader
							  FROM	ItemInventory ii LEFT OUTER JOIN @FileItemDischargeTemp fid ON ii.IdFileDetail = fid.IdFileDetailStock
													 INNER JOIN FileHeader fh ON fh.Id = ii.IdFileHeader
							 WHERE	ii.IdCustomer = @IdCustomer
							   AND	ii.IdAccount = @IdAccount
							   AND	CONVERT(DATE, fh.AuthorizationDate) <= @EndDate)
			   AND	fh.IdDocument like CONCAT('%', @IdDocument, '%')
		END