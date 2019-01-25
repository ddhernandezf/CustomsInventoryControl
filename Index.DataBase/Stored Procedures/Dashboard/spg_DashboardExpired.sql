CREATE PROCEDURE [dbo].[spg_DashboardExpired]
	@IdCustomer	INT,
	@IdAccount	INT
AS
	DECLARE	@TempData TABLE(
		[IdFileHeader] INT NOT NULL,
		[Document] VARCHAR(150) NOT NULL,
		[IdState] INT NOT NULL,
		[StateName] VARCHAR(100) NOT NULL,
		[StartDate] DATETIME NOT NULL,
		[EndDate] DATETIME NOT NULL,
		[Days] INT NOT NULL,
		[IsSubstract] BIT NOT NULL
	)
	
	INSERT INTO @TempData	
	SELECT	fh.Id[IdFileHeader], CONCAT(fi.Name, ' (', fit.Name, ') ', fh.IdDocument)[Document], fh.IdState, s.[Name][StateName],
		CASE WHEN fh.AuthorizationDate IS NULL
			THEN fh.RegisterDate
			ELSE fh.AuthorizationDate
		END[StartDate], fh.ExpirationDate[EndDate], DATEDIFF(day, GETDATE(), fh.ExpirationDate), fic.IsSubstract
	  FROM	[FileHeader] fh INNER JOIN [FileInfoConfig] fic ON fic.Id = fh.IdFileInfoConfig
							INNER JOIN [FileInfo] fi ON fi.Id = fic.IdFileInfo
							INNER JOIN [FileInfoType] fit ON fit.Id = fic.IdFileType
							INNER JOIN [State] s ON s.Id = fh.IdState
	 WHERE	fh.IdAccount = @IdAccount
	   AND	fh.IdCustomer = @IdCustomer
	   
	DELETE FROM @TempData WHERE IsSubstract = 0 AND [Days] <= 0;
	DELETE FROM @TempData WHERE IsSubstract = 1 AND IdState = (SELECT Id FROM [State] WHERE [Name] = 'Transmitido');

	DECLARE	@Total				DECIMAL(18,4),
			@InTime				DECIMAL(18,4),
			@ToExpire			DECIMAL(18,4),
			@Expired			DECIMAL(18,4),
			@InTimePercent		DECIMAL(18,4),
			@ToExpirePercent	DECIMAL(18,4),
			@ExpiredPercent		DECIMAL(18,4),
			@DaysToExpire		INT

	SELECT @DaysToExpire = DaysToExpire FROM [Parameters];
	SELECT @Total = COUNT(*) FROM @TempData;
	SELECT @InTime = COUNT(*) FROM @TempData WHERE [Days] > @DaysToExpire;
	SELECT @ToExpire = COUNT(*) FROM @TempData WHERE [Days] BETWEEN 1 AND @DaysToExpire;
	SELECT @Expired = COUNT(*) FROM @TempData WHERE [Days] < 0;

	SET	@InTimePercent = ((@InTime / @Total) * 100);
	SET	@ToExpirePercent = ((@ToExpire / @Total) * 100);
	SET	@ExpiredPercent = ((@Expired / @Total) * 100);

	SELECT	@Total[Total], @InTime[InTimeQuantity], @ToExpire[ToExpireQuntity], @Expired[ExpiredQuantity],
			CONVERT(DECIMAL(18,2), @InTimePercent)[InTimePercent], CONVERT(DECIMAL(18,2), @ToExpirePercent)[ToExpirePercent],
			CONVERT(DECIMAL(18,2), @ExpiredPercent)[ExpiredPercent]