CREATE PROCEDURE [dbo].[spu_DocumentStartEndProccessTime]
	@IdOpaHeader	INT,
	@IsStartProc	BIT
AS
	DECLARE	@CurrentDateTime	DATETIME;
	SET	@CurrentDateTime = GETDATE();

	IF(@IsStartProc = 1)
		BEGIN
			UPDATE	[OpaHeader]
			   SET	StartDate = @CurrentDateTime
			 WHERE	Id = @IdOpaHeader;

			UPDATE	[OpaQueue]
			   SET	StartDate = @CurrentDateTime
			 WHERE	IdOpaHeader = @IdOpaHeader;
		END
	ELSE
		BEGIN
			UPDATE	[OpaHeader]
			   SET	EndDate = @CurrentDateTime
			 WHERE	Id = @IdOpaHeader;

			UPDATE	[OpaQueue]
			   SET	EndDate = @CurrentDateTime
			 WHERE	IdOpaHeader = @IdOpaHeader;
		END