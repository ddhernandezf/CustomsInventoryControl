CREATE PROCEDURE [dbo].[spu_ItemStartEndProccessTime]
	@IdOpaDetail	INT,
	@IsStartProc	BIT
AS
	DECLARE	@CurrentDateTime	DATETIME;
	SET	@CurrentDateTime = GETDATE();

	IF(@IsStartProc = 1)
		BEGIN
			UPDATE	[OpaDetail]
			   SET	StartDate = @CurrentDateTime
			 WHERE	Id = @IdOpaDetail;
		END
	ELSE
		BEGIN
			UPDATE	[OpaDetail]
			   SET	EndDate = @CurrentDateTime
			 WHERE	Id = @IdOpaDetail;
		END