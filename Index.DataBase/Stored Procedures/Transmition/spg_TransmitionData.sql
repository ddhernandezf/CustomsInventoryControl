CREATE PROCEDURE spg_TransmitionData
	@IdCustomer			INT,
	@IdAccount			INT,
	@UseRegisterDate	BIT,
	@StartDate			DATE,
	@EndDate			DATE
AS
	IF (ISNULL(@UseRegisterDate, 0) = 0)
		BEGIN
			SELECT	fid.Id[IdFileItemDischarge], fhe.Id[IdFileHeaderSubstract], fde.Id[IdFileDetailSubstract],
					fhe.IdDocument[IdDocumentSubstract], fde.TransactionLine[TransactionLineSubstract],
					(fid.Quantity + fid.Decrease)[QuantitySubstract], fid.CIFcost[CifSubstract], fid.FOcost[FobSubstract], 
					fid.CustomDuties[CustomDutiesSubstract], fid.Iva[IvaSubstract], fhi.Id[IdFileHeaderStock], 
					fdi.Id[IdFileDetailStock], fhi.IdDocument[IdDocumentStock], fdi.TransactionLine[TransactionLineStock],
					CONCAT(fie.Name, ' (', fite.Name, ')')[DocumentNameSubstract],
					CONCAT(fii.Name, ' (', fiti.Name, ')')[DocumentNameStock],
					fhe.AuthorizationDate, fhe.RegisterDate
			  FROM	FileItemDischarge fid INNER JOIN FileDetail fde ON fid.IdFileDetailSubstract = fde.Id
										  INNER JOIN FileHeader fhe ON fde.IdFileHeader = fhe.Id
										  INNER JOIN FileInfoConfig fice ON fice.Id = fhe.IdFileInfoConfig
										  INNER JOIN FileInfo fie ON fie.Id = fice.IdFileInfo
										  INNER JOIN FileInfoType fite ON fite.Id = fice.IdFileType
										  INNER JOIN FileDetail fdi ON fid.IdFileDetailStock = fdi.Id
										  INNER JOIN FileHeader fhi ON fdi.IdFileHeader = fhi.Id
										  INNER JOIN FileInfoConfig fici ON fici.Id = fhi.IdFileInfoConfig
										  INNER JOIN FileInfo fii ON fii.Id = fici.IdFileInfo
										  INNER JOIN FileInfoType fiti ON fiti.Id = fici.IdFileType
			 WHERE	CONVERT(DATE, fhe.AuthorizationDate) BETWEEN @StartDate AND @EndDate
			  AND	fhe.IdAccount = @IdAccount
			  AND	fhe.IdCustomer = @IdCustomer
			  AND	fice.Transmissible = 1
			  AND	fid.IdState NOT IN (	SELECT	Id
											  FROM	[State]
											 WHERE	Name IN ('Cola', 'Procesando', 'Espera', 'Validando', 'Valido', 'Transmitiendo', 'Transmitido',
																'Finalizado', 'Error Transmisión'))
		END
	ELSE
		BEGIN
			SELECT	fid.Id[IdFileItemDischarge], fhe.Id[IdFileHeaderSubstract], fde.Id[IdFileDetailSubstract],
					fhe.IdDocument[IdDocumentSubstract], fde.TransactionLine[TransactionLineSubstract],
					(fid.Quantity + fid.Decrease)[QuantitySubstract], fid.CIFcost[CifSubstract], fid.FOcost[FobSubstract], 
					fid.CustomDuties[CustomDutiesSubstract], fid.Iva[IvaSubstract], fhi.Id[IdFileHeaderStock], 
					fdi.Id[IdFileDetailStock], fhi.IdDocument[IdDocumentStock], fdi.TransactionLine[TransactionLineStock],
					CONCAT(fie.Name, ' (', fite.Name, ')')[DocumentNameSubstract],
					CONCAT(fii.Name, ' (', fiti.Name, ')')[DocumentNameStock],
					fhe.AuthorizationDate, fhe.RegisterDate
			  FROM	FileItemDischarge fid INNER JOIN FileDetail fde ON fid.IdFileDetailSubstract = fde.Id
										  INNER JOIN FileHeader fhe ON fde.IdFileHeader = fhe.Id
										  INNER JOIN FileInfoConfig fice ON fice.Id = fhe.IdFileInfoConfig
										  INNER JOIN FileInfo fie ON fie.Id = fice.IdFileInfo
										  INNER JOIN FileInfoType fite ON fite.Id = fice.IdFileType
										  INNER JOIN FileDetail fdi ON fid.IdFileDetailStock = fdi.Id
										  INNER JOIN FileHeader fhi ON fdi.IdFileHeader = fhi.Id
										  INNER JOIN FileInfoConfig fici ON fici.Id = fhi.IdFileInfoConfig
										  INNER JOIN FileInfo fii ON fii.Id = fici.IdFileInfo
										  INNER JOIN FileInfoType fiti ON fiti.Id = fici.IdFileType
			 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate AND @EndDate
			  AND	fhe.IdAccount = @IdAccount
			  AND	fhe.IdCustomer = @IdCustomer
			  AND	fice.Transmissible = 1
			  AND	fid.IdState NOT IN (	SELECT	Id
											  FROM	[State]
											 WHERE	Name IN ('Cola', 'Procesando', 'Espera', 'Validando', 'Valido', 'Transmitiendo', 'Transmitido',
																'Finalizado', 'Error Transmisión'))
		END