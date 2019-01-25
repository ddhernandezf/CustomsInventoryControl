CREATE PROCEDURE [dbo].[spg_FileDetailValidationData]
	@IdFileDetail	INT
AS
	DECLARE	@HasMove	BIT,
			@CountSubs	INT,
			@CountStock	INT

	DECLARE @TempFileDetail TABLE (
		[HasMove]		BIT NOT NULL,
		[IdState]		INT NOT NULL,
		[StateName]		VARCHAR(100) NOT NULL
	)

	SELECT	@CountStock = COUNT(*)
	  FROM	FileItemDischarge
	 WHERE	IdFileDetailStock = @IdFileDetail

	SELECT	@CountSubs = COUNT(*)
	  FROM	FileItemDischarge
	 WHERE	IdFileDetailSubstract = @IdFileDetail

	SET @HasMove = CASE WHEN (@CountSubs + @CountStock) = 0 THEN CONVERT(BIT, 0) ELSE CONVERT(BIT, 1) END

	INSERT INTO @TempFileDetail(HasMove, IdState,StateName)
	SELECT	@HasMove, fd.IdState, s.[Name]
	  FROM [FileDetail] fd INNER JOIN [State] s ON s.Id = fd.IdState
	 WHERE	fd.Id= @IdFileDetail

	SELECT	HasMove, IdState,StateName
	  FROM	@TempFileDetail