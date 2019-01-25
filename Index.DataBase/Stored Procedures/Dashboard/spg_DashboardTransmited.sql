CREATE PROCEDURE [dbo].[spg_DashboardTransmited]
	@IdCustomer	INT,
	@IdAccount	INT
AS
	DECLARE	@TempData TABLE(
		[IdFileHeader] INT NOT NULL,
		[Document] VARCHAR(150) NOT NULL,
		[IdState] INT NOT NULL
	)

	INSERT INTO @TempData
	SELECT	fh.Id[IdFileHeader], CONCAT(fi.Name, ' (', fit.Name, ') ', fh.IdDocument)[Document], fh.IdState
	  FROM	[FileHeader] fh INNER JOIN [FileInfoConfig] fic ON fic.Id = fh.IdFileInfoConfig
							INNER JOIN [FileInfo] fi ON fi.Id = fic.IdFileInfo
							INNER JOIN [FileInfoType] fit ON fit.Id = fic.IdFileType
	 WHERE	fh.IdAccount = @IdAccount
	   AND	fh.IdCustomer = @IdCustomer
	   AND	fic.LoadRawMaterial = 1
	   AND	fic.IsSubstract = 1

	DECLARE	@Saved				DECIMAL(18,4),
			@Transmited			DECIMAL(18,4),
			@Queue				DECIMAL(18,4),
			@SavedPercent		DECIMAL(18,4),
			@TransmitedPercent	DECIMAL(18,4),
			@QueuePercent		DECIMAL(18,4),
			@Total				INT,
			@IdStateSaved		INT,
			@IdStateQueue		INT,
			@IdStateTransmited	INT
			
	SELECT @IdStateSaved = Id FROM [State] WHERE [Name] = 'Grabado';
	SELECT @IdStateQueue = Id FROM [State] WHERE [Name] = 'Cola';
	SELECT @IdStateTransmited = Id FROM [State] WHERE [Name] = 'Transmitido';
	
	SELECT @Total = COUNT(*) FROM @TempData;
	SELECT @Saved = COUNT(*) FROM @TempData WHERE IdState = @IdStateSaved;
	SELECT @Queue = COUNT(*) FROM @TempData WHERE IdState = @IdStateQueue;
	SELECT @Transmited = COUNT(*) FROM @TempData WHERE IdState = @IdStateTransmited;
	
	SET	@SavedPercent = ((@Saved / @Total) * 100);
	SET	@QueuePercent = ((@Queue / @Total) * 100);
	SET	@TransmitedPercent = ((@Transmited / @Total) * 100);

	SELECT	@Total[Total], @Saved[SavedQuantity], @Queue[QueueQuantity], @Transmited[TransmitedQuantity],
			CONVERT(DECIMAL(18,2), @SavedPercent)[SavedPercent],CONVERT(DECIMAL(18,2), @QueuePercent)[QueuePercent], 
			CONVERT(DECIMAL(18,2), @TransmitedPercent)[TransmitedPercent]