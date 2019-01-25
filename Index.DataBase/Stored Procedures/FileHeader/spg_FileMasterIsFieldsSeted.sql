CREATE PROCEDURE [dbo].[spg_FileMasterIsFieldsSeted]
	@IdFileInfoConfig	INT
AS
	SELECT	CASE WHEN COUNT(*) > 0
				THEN CONVERT(BIT, 1)
				ELSE CONVERT(BIT, 0)
			END[FieldsSeted]
	  FROM	[FileMasterDisplay]
	 WHERE	IdFileInfoConfig = @IdFileInfoConfig