CREATE PROCEDURE [dbo].[spg_OpaDetail]
	@IdOpaHeader	INT
AS
	DECLARE	@CurrentIdState	INT,
			@IdStateTransmited INT;

	SELECT @CurrentIdState = IdState FROM [OpaHeader] WHERE Id = @IdOpaHeader;
	SELECT @IdStateTransmited = Id FROM [State] WHERE [Name] = 'Transmitido';
	
	IF(@IdStateTransmited = @CurrentIdState)
		BEGIN
			SELECT	od.Id[IdOpaDetail], IdOpaHeader, od.IdState, s.[Name][StateName], 
					IdFileItemDischarge, IdFileHeaderSubstract, IdFileDetailSubstract, IdDocumentSubstract,TransactionLineSubstract, 
					CONCAT(fie.[Name], ' (', fite.[Name], ')')[DocumentNameSubstract],
					QuantitySubstract, CifSubstract, FobSubstract, CustomDutiesSubstract, IvaSubstract, 
					IdFileHeaderStock, IdFileDetailStock, IdDocumentStock, TransactionLineStock, StartDate, EndDate,
					CONCAT(fii.[Name], ' (', fiti.[Name], ')')[DocumentNameStock], 
					(	SELECT	COUNT(*)
						  FROM	[OpaResponse]
						 WHERE	IdOpaDetail = od.Id)[Error]
			  FROM	[OpaDetailHist] od INNER JOIN [State] s ON od.IdState = s.Id
								   INNER JOIN [FileHeader] fhe ON od.IdFileHeaderSubstract = fhe.Id
								   INNER JOIN [FileDetail] fde ON od.IdFileDetailSubstract = fde.Id
								   INNER JOIN [FileInfoConfig] fice ON fhe.IdFileInfoConfig = fice.Id
								   INNER JOIN [FileInfo] fie ON fice.IdFileInfo = fie.Id
								   INNER JOIN [FileInfoType] fite ON fice.IdFileType = fite.Id
								   INNER JOIN [FileHeader] fhi ON od.IdFileHeaderStock = fhi.Id
								   INNER JOIN [FileDetail] fdi ON od.IdFileDetailStock = fdi.Id
								   INNER JOIN [FileInfoConfig] fici ON fhi.IdFileInfoConfig = fici.Id
								   INNER JOIN [FileInfo] fii ON fici.IdFileInfo = fii.Id
								   INNER JOIN [FileInfoType] fiti ON fici.IdFileType = fiti.Id
			 WHERE	IdOpaHeader = @IdOpaHeader;
		END
	ELSE
		BEGIN
			SELECT	od.Id[IdOpaDetail], IdOpaHeader, od.IdState, s.[Name][StateName], 
					IdFileItemDischarge, IdFileHeaderSubstract, IdFileDetailSubstract, IdDocumentSubstract,TransactionLineSubstract, 
					CONCAT(fie.[Name], ' (', fite.[Name], ')')[DocumentNameSubstract],
					QuantitySubstract, CifSubstract, FobSubstract, CustomDutiesSubstract, IvaSubstract, 
					IdFileHeaderStock, IdFileDetailStock, IdDocumentStock, TransactionLineStock, StartDate, EndDate,
					CONCAT(fii.[Name], ' (', fiti.[Name], ')')[DocumentNameStock], 
					(	SELECT	COUNT(*)
						  FROM	[OpaResponse]
						 WHERE	IdOpaDetail = od.Id)[Error]
			  FROM	[OpaDetail] od INNER JOIN [State] s ON od.IdState = s.Id
								   INNER JOIN [FileHeader] fhe ON od.IdFileHeaderSubstract = fhe.Id
								   INNER JOIN [FileDetail] fde ON od.IdFileDetailSubstract = fde.Id
								   INNER JOIN [FileInfoConfig] fice ON fhe.IdFileInfoConfig = fice.Id
								   INNER JOIN [FileInfo] fie ON fice.IdFileInfo = fie.Id
								   INNER JOIN [FileInfoType] fite ON fice.IdFileType = fite.Id
								   INNER JOIN [FileHeader] fhi ON od.IdFileHeaderStock = fhi.Id
								   INNER JOIN [FileDetail] fdi ON od.IdFileDetailStock = fdi.Id
								   INNER JOIN [FileInfoConfig] fici ON fhi.IdFileInfoConfig = fici.Id
								   INNER JOIN [FileInfo] fii ON fici.IdFileInfo = fii.Id
								   INNER JOIN [FileInfoType] fiti ON fici.IdFileType = fiti.Id
			 WHERE	IdOpaHeader = @IdOpaHeader;
		END