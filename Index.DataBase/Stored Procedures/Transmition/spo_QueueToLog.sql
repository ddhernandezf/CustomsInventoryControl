CREATE PROCEDURE [dbo].[spo_QueueToLog]
	@IdOpaHeader	INT
AS
	INSERT INTO [OpaQueueLog]
	SELECT	*
	  FROM	[OpaQueue]
	 WHERE	IdOpaHeader = @IdOpaHeader;

	SET IDENTITY_INSERT [OpaDetailHist] ON;
	INSERT INTO [OpaDetailHist](Id, IdOpaHeader, IdState, IdFileItemDischarge, IdFileHeaderSubstract, IdFileDetailSubstract,
					IdDocumentSubstract, TransactionLineSubstract, QuantitySubstract, CifSubstract, FobSubstract,
					CustomDutiesSubstract, IvaSubstract, IdFileHeaderStock, IdFileDetailStock, IdDocumentStock,
					TransactionLineStock, StartDate, EndDate)
	SELECT	Id, IdOpaHeader, IdState, IdFileItemDischarge, IdFileHeaderSubstract, IdFileDetailSubstract,
					IdDocumentSubstract, TransactionLineSubstract, QuantitySubstract, CifSubstract, FobSubstract,
					CustomDutiesSubstract, IvaSubstract, IdFileHeaderStock, IdFileDetailStock, IdDocumentStock,
					TransactionLineStock, StartDate, EndDate
	  FROM	[OpaDetail]
	 WHERE	IdOpaHeader = @IdOpaHeader;
	SET IDENTITY_INSERT [OpaDetailHist] OFF;
	 
	DELETE FROM [OpaQueue] WHERE IdOpaHeader = @IdOpaHeader;
	DELETE FROM [OpaDetail] WHERE IdOpaHeader = @IdOpaHeader;