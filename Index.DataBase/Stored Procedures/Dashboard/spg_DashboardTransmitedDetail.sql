CREATE PROCEDURE [dbo].[spg_DashboardTransmitedDetail]
	@IdCustomer	INT,
	@IdAccount	INT
AS
	SELECT	fh.Id[IdFileHeader], CONCAT(fi.Name, ' (', fit.Name, ') ', fh.IdDocument)[Document], fh.IdState, s.[Name][StateName]
	  FROM	[FileHeader] fh INNER JOIN [FileInfoConfig] fic ON fic.Id = fh.IdFileInfoConfig
							INNER JOIN [FileInfo] fi ON fi.Id = fic.IdFileInfo
							INNER JOIN [FileInfoType] fit ON fit.Id = fic.IdFileType
							INNER JOIN [State] s ON s.Id = fh.IdState
	 WHERE	fh.IdAccount = @IdAccount
	   AND	fh.IdCustomer = @IdCustomer
	   AND	fic.LoadRawMaterial = 1
	   AND	fic.IsSubstract = 1