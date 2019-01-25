CREATE PROCEDURE [dbo].[spg_FileInfo]
	@IdFileInfo	INT
AS
	IF(ISNULL(@IdFileInfo, 0) = 0)
		BEGIN
			SELECT	Id, Name, [Description]
			  FROM	[FileInfo]
		END
	ELSE
		BEGIN
			SELECT	Id, Name, [Description]
			  FROM	[FileInfo]
			 WHERE	Id = @IdFileInfo
		END
