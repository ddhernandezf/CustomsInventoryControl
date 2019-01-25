CREATE PROCEDURE [spd_FileAttached]
	@IdFileAttached	INT
AS
	DECLARE	@State			VARCHAR(100),
			@IdFileHeader	INT,
			@LastStock		INT,
			@IdItem			INT

	SELECT	@IdFileHeader =IdFileHeader
	  FROM	[FileAttached] 
	 WHERE Id = @IdFileAttached

	SELECT	@State = UPPER(s.Name)
	  FROM	[FileHeader] f INNER JOIN [State] s ON s.Id = f.IdState
	 WHERE	f.Id = @IdFileHeader
	
	IF(@State <> 'REVISADO')
		BEGIN
			DELETE FROM [FileAttached] WHERE Id = @IdFileAttached
		END
	ELSE
		BEGIN
			RAISERROR (N'El documento ya se encuentra revisado, por lo tanto no se pueden realizar modificaciones.',16,1);
		END