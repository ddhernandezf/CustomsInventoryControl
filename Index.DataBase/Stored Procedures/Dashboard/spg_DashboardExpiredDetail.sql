CREATE PROCEDURE [dbo].[spg_DashboardExpiredDetail]
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

	DECLARE	@DaysToExpire	INT
	SELECT @DaysToExpire = DaysToExpire FROM [Parameters];

	SELECT	IdFileHeader, Document, IdState, StateName, StartDate, EndDate, [Days],
			CASE WHEN [Days] > @DaysToExpire THEN 'En tiempo'
				 WHEN [Days] BETWEEN 1 AND @DaysToExpire THEN  'Por expirar'
				 WHEN [Days] < 0 THEN 'Expirado'
				ELSE NULL
			END[Label]
	  FROM	@TempData