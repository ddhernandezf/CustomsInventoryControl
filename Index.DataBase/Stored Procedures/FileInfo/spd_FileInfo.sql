CREATE PROCEDURE [dbo].[spd_FileInfo]
	@IdFileInfo	INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[FileInfoConfig]
				 WHERE	IdFileInfo = @IdFileInfo))
	BEGIN
		RAISERROR (N'El documento posee configuraciones. No se puede borrar.',16,1);
	END
	ELSE
	BEGIN
		DELETE FROM [FileInfo] WHERE Id = @IdFileInfo;
	END
