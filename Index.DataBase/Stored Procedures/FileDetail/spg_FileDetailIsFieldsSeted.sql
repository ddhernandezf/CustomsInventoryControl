CREATE PROCEDURE [dbo].[spg_FileDetailIsFieldsSeted]
	@IdFileInfoConfig	INT
AS
	SELECT	CASE WHEN COUNT(*) > 0
				THEN CONVERT(BIT, 1)
				ELSE CONVERT(BIT, 0)
			END[FieldsSeted]
	  FROM	[FileDetailDisplay]
	 WHERE	IdFileInfoConfig = @IdFileInfoConfig