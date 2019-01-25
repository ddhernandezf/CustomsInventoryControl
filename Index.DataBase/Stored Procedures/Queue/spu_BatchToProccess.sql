CREATE PROCEDURE [dbo].[spu_BatchToProccess]
	@IdOpaHeader	INT
AS
	DECLARE	@ProcState	INT
	SELECT @ProcState = Id FROM [State] WHERE [Name] = 'Procesando'

	IF EXISTS (	SELECT	*
				  FROM	OpaQueue
				 WHERE	IdState = @ProcState)
		BEGIN
			RAISERROR (N'Actualmente se encuentra un lote en proceso.',16,1);
		END
	ELSE
		BEGIN
			UPDATE	[OpaQueue]
			   SET	IdState = @ProcState
			 WHERE	IdOpaHeader = @IdOpaHeader;

			UPDATE	[OpaHeader]
			   SET	IdState = @ProcState
			 WHERE	Id = @IdOpaHeader;
		END