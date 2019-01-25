CREATE PROCEDURE [dbo].[spg_QueueItems]
	@IdHeader	INT
AS
	DECLARE	@ProcState		INT,
			@ColaState		INT,
			@IdOpaHeader	INT

	SELECT @ProcState = Id FROM [State] WHERE [Name] = 'Procesando';
	SELECT @ColaState = Id FROM [State] WHERE [Name] = 'Cola';
	SELECT @IdOpaHeader = IdOpaHeader FROM [OpaQueue] WHERE IdState = @ProcState;


	UPDATE	[OpaDetail]
	   SET	IdState = @ProcState
	 WHERE	IdOpaHeader = @IdOpaHeader
	   AND	IdState = @ColaState

	SELECT	oq.IdOpaHeader, od.Id[IdOpaDetail], oh.Nit, od.IdDocumentStock, od.TransactionLineStock, od.QuantitySubstract, od.IdDocumentSubstract,
			od.TransactionLineSubstract, od.IdState, od.CifSubstract, od.CustomDutiesSubstract, od.IvaSubstract
	  FROM	[OpaQueue] oq INNER JOIN [OpaHeader] oh ON oh.Id = oq.IdOpaHeader
						  INNER JOIN [OpaDetail] od ON od.IdOpaHeader = oq.IdOpaHeader
	 WHERE	oq.IdOpaHeader = @IdHeader