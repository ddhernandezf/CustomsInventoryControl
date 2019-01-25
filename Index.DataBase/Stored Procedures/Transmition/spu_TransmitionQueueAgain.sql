CREATE PROCEDURE [dbo].[spu_TransmitionQueueAgain]
	@IdOpaDetail	INT
AS
	DECLARE @IdStateQueue		INT,
			@IdStateTransmited	INT,
			@IdOpaHeader		INT,
			@OpaHeaderState		INT,
			@OpaDetailState		INT;
			
	SELECT @IdStateQueue = Id FROM [State] WHERE [Name] = 'Cola';
	SELECT @IdStateTransmited = Id FROM [State] WHERE [Name] = 'Transmitido';
	
	SELECT	@IdOpaHeader = oh.Id, @OpaHeaderState = oh.IdState, @OpaDetailState = od.IdState
	  FROM	[OpaDetail] od INNER JOIN [OpaHeader] oh ON oh.Id = od.IdOpaHeader
	 WHERE	od.Id = @IdOpaDetail;

	IF(@OpaDetailState = @IdStateTransmited)
		BEGIN
			RAISERROR (N'El registro ya se encuentra transmitido. No puede ser procesado de nuevo.',16,1);
		END
	ELSE
		BEGIN
			IF(@OpaHeaderState <> @IdStateQueue)
				BEGIN
					UPDATE	OpaHeader
					   SET	IdState = @IdStateQueue
					 WHERE	Id = @IdOpaHeader;

					UPDATE	OpaQueue
					   SET	IdState = @IdStateQueue
					 WHERE	IdOpaHeader = @IdOpaHeader;
				END

			UPDATE	OpaDetail
			   SET	IdState = @IdStateQueue
			 WHERE	Id = @IdOpaDetail;
		END