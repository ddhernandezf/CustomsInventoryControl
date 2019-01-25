CREATE PROCEDURE [dbo].[spu_DocumentChangeState]
	@IdOpaHeader	INT,
	@IdState		INT
AS
	DECLARE	@IdStateTransmited	INT;

	SELECT @IdStateTransmited = Id FROM [State] WHERE [Name] = 'Transmitido';

	UPDATE	[OpaHeader]
	   SET	IdState = @IdState
	 WHERE Id= @IdOpaHeader;

	UPDATE	[OpaQueue]
	   SET	IdState = @IdState
	 WHERE IdOpaHeader= @IdOpaHeader;

	IF(@IdStateTransmited = @IdState)
		BEGIN
			INSERT INTO [OpaQueueLog] (IdOpaHeader, IdPriority, IdState, [DEscription], StartDate, EndDate)
			SELECT	IdOpaHeader, IdPriority, IdState, [DEscription], StartDate, EndDate
			  FROM [OpaQueue]
			 WHERE IdOpaHeader = @IdOpaHeader

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

			SET IDENTITY_INSERT [OpaResponseHist] ON;
			INSERT INTO [OpaResponseHist] (Id, IdOpaDetail, TransactionNumber, ErrorType, ErrorMessage, Cif, CustomDuties, Iva,
											NationalizationMulct, NationalizationMulctAmmount, ExtemporaneusMulct,
											ExtemporaneusMulctAmmount, ResponseDate)
			SELECT	opr.Id, opr.IdOpaDetail, opr.TransactionNumber, opr.ErrorType, opr.ErrorMessage, opr.Cif, opr.CustomDuties, opr.Iva,
					opr.NationalizationMulct, opr.NationalizationMulctAmmount, opr.ExtemporaneusMulct,
					opr.ExtemporaneusMulctAmmount, opr.ResponseDate
			  FROM	[OpaResponse] opr INNER JOIN [OpaDetail] od ON od.Id = opr.IdOpaDetail
			 WHERE	od.IdOpaHeader = @IdOpaHeader
			ORDER BY opr.IdOpaDetail;
			SET IDENTITY_INSERT [OpaResponseHist] OFF;

			--DELETE FROM [OpaResponse] WHERE IdOpaDetail IN (SELECT IdOpaDetail FROM OpaDetail WHERE IdOpaHeader = @IdOpaHeader);
			--DELETE FROM [OpaDetail] WHERE IdOpaHeader = @IdOpaHeader;
			--DELETE FROM [OpaQueue] WHERE IdOpaHeader = @IdOpaHeader
		END