CREATE PROCEDURE [dbo].[spg_Report_DischargeDetail_FilteredHeader]
	@TransFlag	BIT,
	@StartDate	DATE,
	@EndDate	DATE,
	@IdCustomer	INT,
	@IdAccount	INT, 
	@IdDocument	VARCHAR(100)
AS

	DECLARE @DetailTemp TABLE (
		[IdFileDetailTemp]	INT NOT NULL
	)
	
	IF(@TransFlag IS NULL)
		BEGIN
			IF (ISNULL(@IdDocument, '') = '')
				BEGIN
					INSERT INTO @DetailTemp(IdFileDetailTemp)
					SELECT	DISTINCT fid.IdFileDetailStock
					  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
													INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
					   AND	fhi.IdCustomer = @IdCustomer
					   AND	fhi.IdAccount = @IdAccount;
				END
			ELSE
				BEGIN
					INSERT INTO @DetailTemp(IdFileDetailTemp)
					SELECT	DISTINCT fid.IdFileDetailStock
					  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
													INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
					   AND	fhi.IdCustomer = @IdCustomer
					   AND	fhi.IdAccount = @IdAccount
					   AND	fhi.IdDocument like CONCAT('%', @IdDocument , '%');
				END
		END
	ELSE
		BEGIN
			DECLARE	@IdStateTransmited	INT;
			SELECT @IdStateTransmited = Id FROM [State] WHERE [Name] = 'Transmitido';

			IF(@TransFlag = 1)
				BEGIN
					IF (ISNULL(@IdDocument, '') = '')
						BEGIN
							INSERT INTO @DetailTemp(IdFileDetailTemp)
							SELECT	DISTINCT fid.IdFileDetailStock
							  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
															INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
							 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
							   AND	fhi.IdCustomer = @IdCustomer
							   AND	fhi.IdAccount = @IdAccount
							   AND	fid.IdState = @IdStateTransmited;
						END
					ELSE
						BEGIN
							INSERT INTO @DetailTemp(IdFileDetailTemp)
							SELECT	DISTINCT fid.IdFileDetailStock
							  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
															INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
							 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
							   AND	fhi.IdCustomer = @IdCustomer
							   AND	fhi.IdAccount = @IdAccount
							   AND	fid.IdState = @IdStateTransmited
							   AND	fhi.IdDocument like CONCAT('%', @IdDocument , '%');
						END
				END
			ELSE IF(@TransFlag = 0)
				BEGIN
					IF (ISNULL(@IdDocument, '') = '')
						BEGIN
							INSERT INTO @DetailTemp(IdFileDetailTemp)
							SELECT	DISTINCT fid.IdFileDetailStock
							  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
															INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
							 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
							   AND	fhi.IdCustomer = @IdCustomer
							   AND	fhi.IdAccount = @IdAccount
							   AND	fid.IdState <> @IdStateTransmited;
						END
					ELSE
						BEGIN
							INSERT INTO @DetailTemp(IdFileDetailTemp)
							SELECT	DISTINCT fid.IdFileDetailStock
							  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
															INNER JOIN [FileHeader] fhi ON fhi.id = fdi.IdFileHeader
							 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate and @EndDate
							   AND	fhi.IdCustomer = @IdCustomer
							   AND	fhi.IdAccount = @IdAccount
							   AND	fid.IdState <> @IdStateTransmited
							   AND	fhi.IdDocument like CONCAT('%', @IdDocument , '%');
						END
				END
		END
	
	SELECT	DISTINCT fh.Id, fh.IdCustomer, fh.IdFileInfoConfig, CONCAT(fi.[Name], ' (', fit.[Name], ')')[FileInfoName],
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
	  FROM	[FileDetail] fd INNER JOIN FileHeader fh ON fh.Id = fd.IdFileHeader
							INNER JOIN FileInfoConfig fic ON fic.Id = fh.IdFileInfoConfig
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
	 WHERE	fd.Id IN (SELECT IdFileDetailTemp FROM @DetailTemp)
	 ORDER BY CASE WHEN fic.IsSubstract = 1 
								THEN '(-)'
								ELSE '(+)'
							END