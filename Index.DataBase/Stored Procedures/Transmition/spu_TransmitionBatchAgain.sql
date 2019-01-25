CREATE PROCEDURE [dbo].[spu_TransmitionBatchAgain]
	@IdOpaHeader	INT
AS
	DECLARE	@IdStateQueue	INT,
			@IdStateError	INT;
			
	SELECT @IdStateQueue = Id FROM [State] WHERE [Name] = 'Cola';
	SELECT @IdStateError = Id FROM [State] WHERE [Name] = 'Error Transmisión';

	UPDATE	[OpaQueue]
	   SET	IdState = @IdStateQueue
	 WHERE	IdOpaHeader = @IdOpaHeader;

	UPDATE	[OpaHeader]
	   SET	IdState = @IdStateQueue
	 WHERE	Id = @IdOpaHeader;

	UPDATE	[OpaDetail]
	   SET	IdState = @IdStateQueue
	 WHERE	IdOpaHeader = @IdOpaHeader
	   AND	IdState = @IdStateError;