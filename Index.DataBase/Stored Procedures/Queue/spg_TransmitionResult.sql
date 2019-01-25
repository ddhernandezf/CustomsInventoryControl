CREATE PROCEDURE [dbo].[spg_TransmitionResult]
	@IdOpaHeader	INT
AS
	IF EXISTS(	SELECT	*
				  FROM	[OpaDetail]
				 WHERE	IdOpaHeader = @IdOpaHeader)
		BEGIN
			SELECT	od.IdState, s.[Name][StateName], 
					(	SELECT	TOP 1 ErrorMessage 
						  FROM	OpaResponse
						 WHERE	IdOpaDetail = od.Id
						 ORDER BY ResponseDate DESC)[Message], 
					CONCAT(fie.[Name], ' (', fte.[Name], ') ', fhe.IdDocument, ' Línea ', fde.TransactionLine)[ExportInfo],
					CONCAT(fii.[Name], ' (', fti.[Name], ') ', fhi.IdDocument, ' Línea ', fdi.TransactionLine)[ImportInfo],
					od.QuantitySubstract[Quantity], OD.CifSubstract[CIF], od.FobSubstract[FOB], od.CustomDutiesSubstract[DAI], 
					OD.IvaSubstract[IVA]
			  FROM	[OpaDetail] od INNER JOIN [State] s ON s.Id = od.IdState
								   INNER JOIN [FileHeader] fhe ON fhe.Id = od.IdFileHeaderSubstract
								   INNER JOIN [FileDetail] fde ON fde.Id = od.IdFileDetailSubstract
								   INNER JOIN [FileHeader] fhi ON fhi.Id = od.IdFileHeaderStock
								   INNER JOIN [FileDetail] fdi ON fdi.Id = od.IdFileDetailStock
								   INNER JOIN [FileInfoConfig] fice ON fice.Id = fhe.IdFileInfoConfig
								   INNER JOIN [FileInfo] fie ON fie.Id = fice.IdFileInfo
								   INNER JOIN [FileInfoType] fte ON fte.Id = fice.IdFileType
								   INNER JOIN [FileInfoConfig] fici ON fici.Id = fhi.IdFileInfoConfig
								   INNER JOIN [FileInfo] fii ON fii.Id = fici.IdFileInfo
								   INNER JOIN [FileInfoType] fti ON fti.Id = fici.IdFileType
			 WHERE	od.IdOpaHeader = @IdOpaHeader
		END
	ELSE
		BEGIN
			SELECT	od.IdState, s.[Name][StateName], 
					(	SELECT	TOP 1 ErrorMessage 
						  FROM	OpaResponseHist
						 WHERE	IdOpaDetail = od.Id
						 ORDER BY ResponseDate DESC)[Message], 
					CONCAT(fie.[Name], ' (', fte.[Name], ') ', fhe.IdDocument, ' Línea ', fde.TransactionLine)[ExportInfo],
					CONCAT(fii.[Name], ' (', fti.[Name], ') ', fhi.IdDocument, ' Línea ', fdi.TransactionLine)[ImportInfo],
					od.QuantitySubstract[Quantity], OD.CifSubstract[CIF], od.FobSubstract[FOB], od.CustomDutiesSubstract[DAI], 
					OD.IvaSubstract[IVA]
			  FROM	[OpaDetailHist] od INNER JOIN [State] s ON s.Id = od.IdState
								   INNER JOIN [FileHeader] fhe ON fhe.Id = od.IdFileHeaderSubstract
								   INNER JOIN [FileDetail] fde ON fde.Id = od.IdFileDetailSubstract
								   INNER JOIN [FileHeader] fhi ON fhi.Id = od.IdFileHeaderStock
								   INNER JOIN [FileDetail] fdi ON fdi.Id = od.IdFileDetailStock
								   INNER JOIN [FileInfoConfig] fice ON fice.Id = fhe.IdFileInfoConfig
								   INNER JOIN [FileInfo] fie ON fie.Id = fice.IdFileInfo
								   INNER JOIN [FileInfoType] fte ON fte.Id = fice.IdFileType
								   INNER JOIN [FileInfoConfig] fici ON fici.Id = fhi.IdFileInfoConfig
								   INNER JOIN [FileInfo] fii ON fii.Id = fici.IdFileInfo
								   INNER JOIN [FileInfoType] fti ON fti.Id = fici.IdFileType
			 WHERE	od.IdOpaHeader = @IdOpaHeader
		END