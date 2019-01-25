CREATE PROCEDURE [dbo].[spg_FileInfoConfigActiveValidate]
	@IdFileInfoConfig	INT
AS
	SELECT	Active
	  FROM	FileInfoConfig
	 WHERE	Id = @IdFileInfoConfig;
