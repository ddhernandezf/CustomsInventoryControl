CREATE PROCEDURE [dbo].[spg_FileHeaderUsAttached]
	@IdFileHeader	INT
AS
	SELECT	fic.UseAttached
	  FROM	FileHeader fh INNER JOIN FileInfoConfig fic ON fic.Id = fh.IdFileInfoConfig
	 WHERE	fh.Id = @IdFileHeader