CREATE PROCEDURE [dbo].[spg_FileHeaderValidationData]
	@IdFileHeader	INT
AS
	DECLARE	@HasAttached	BIT,
			@HasDetail		BIT

	DECLARE @TempFileDetail TABLE (
		[HasAttached]	BIT NOT NULL,
		[HasDetail]		BIT NOT NULL,
		[IdState]		INT NOT NULL,
		[StateName]		VARCHAR(100) NOT NULL
	)

	SELECT	@HasAttached = CASE WHEN COUNT(*) = 0 THEN CONVERT(BIT, 0) ELSE CONVERT(BIT, 1) END
	  FROM	FileAttached
	 WHERE	IdFileHeader = @IdFileHeader

	SELECT	@HasDetail = CASE WHEN COUNT(*) = 0 THEN CONVERT(BIT, 0) ELSE CONVERT(BIT, 1) END
	  FROM	FileDetail
	 WHERE	IdFileHeader = @IdFileHeader

	DECLARE	@UseAttached BIT;
	SELECT	@UseAttached = fic.UseAttached
	  FROM	FileHeader fh INNER JOIN FileInfoConfig fic ON fic.Id = fh.IdFileInfoConfig
	 WHERE	fh.Id = @IdFileHeader

	IF(@UseAttached = 0)
		BEGIN
			SET @HasAttached = 0;
		END

	INSERT INTO @TempFileDetail(HasAttached,HasDetail, IdState,StateName)
	SELECT	@HasAttached, @HasDetail, fh.IdState, s.[Name]
	  FROM	[FileHeader] fh INNER JOIN [State] s ON s.Id = fh.IdState
	 WHERE	fh.Id = @IdFileHeader

	SELECT	HasAttached,HasDetail, IdState,StateName
	  FROM	@TempFileDetail