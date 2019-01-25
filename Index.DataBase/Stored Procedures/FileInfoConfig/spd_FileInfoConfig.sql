CREATE PROCEDURE [dbo].[spd_FileInfoConfig]
	@IdFileInfoConfig	INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[FileHeader]
				 WHERE	IdFileInfoConfig = @IdFileInfoConfig))
		BEGIN
			RAISERROR (N'Este documento cuenta con registros. No se puede eliminar-',16,1);
		END
	ELSE
		BEGIN
			DELETE FROM [FileInfoConfig] WHERE Id = @IdFileInfoConfig;
		END
