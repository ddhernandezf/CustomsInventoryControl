CREATE PROCEDURE [dbo].[spg_FileMasterDisplay]
	@IdFileInfoConfig	INT
AS
	IF(ISNULL(@IdFileInfoConfig, 0) = 0)
	BEGIN
		SELECT fm.Id, fm.IdFileInfoConfig, f.Id[IdField], f.Name, f.DataBaseName, fm.Label, fm.IsUsed, fm.IsRequeried
		  FROM [Table] t INNER JOIN [Fields] f on f.IdTable = t.Id
						 left JOIN [FileMasterDisplay] fm ON fm.IdField = f.Id 
		 WHERE	t.Name = 'FileHeader'
	END
	ELSE
	BEGIN
		SELECT fm.Id, fm.IdFileInfoConfig, f.Id[IdField], f.Name, f.DataBaseName, fm.Label, fm.IsUsed, fm.IsRequeried
		  FROM [Table] t INNER JOIN [Fields] f on f.IdTable = t.Id
						 left JOIN [FileMasterDisplay] fm ON fm.IdField = f.Id 
														  AND fm.IdFileInfoConfig = @IdFileInfoConfig
		 WHERE	t.Name = 'FileHeader'
	END