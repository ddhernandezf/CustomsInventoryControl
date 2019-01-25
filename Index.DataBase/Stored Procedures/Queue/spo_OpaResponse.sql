CREATE PROCEDURE [dbo].[spo_OpaResponse]
	@IdOpaDetail					INT,
	@TransactionNumber				INT,
	@ErrorType						VARCHAR(1),
	@ErrorMessage					VARCHAR(350),
	@Cif							DECIMAL(18,6),
	@CustomDuties					DECIMAL(18,6),
	@Iva							DECIMAL(18,6),
	@NationalizationMulct			VARCHAR(200),
	@NationalizationMulctAmmount	DECIMAL(18,6),
	@ExtemporaneusMulct				VARCHAR(200),
	@ExtemporaneusMulctAmmount		DECIMAL(18,6),
	@ResponseDate					DATETIME
AS
	--IF EXISTS(	SELECT	*
	--			  FROM	[OpaResponse]
	--			 WHERE	IdOpaDetail = @IdOpaDetail)
	--	BEGIN
	--		UPDATE	[OpaResponse]
	--		   SET	TransactionNumber = @TransactionNumber,
	--				ErrorType = @ErrorType,
	--				ErrorMessage = @ErrorMessage,
	--				Cif = @Cif,
	--				CustomDuties = @CustomDuties,
	--				Iva = @Iva,
	--				NationalizationMulct = @NationalizationMulct,
	--				NationalizationMulctAmmount = @NationalizationMulctAmmount,
	--				ExtemporaneusMulct = @ExtemporaneusMulct,
	--				ExtemporaneusMulctAmmount = @ExtemporaneusMulctAmmount,
	--				ResponseDate = @ResponseDate
	--		 WHERE	IdOpaDetail = @IdOpaDetail;
	--	END
	--ELSE
		BEGIN
			INSERT INTO [OpaResponse](IdOpaDetail, TransactionNumber, ErrorType, ErrorMessage, Cif, CustomDuties, Iva,
										NationalizationMulct, NationalizationMulctAmmount, ExtemporaneusMulct,
										ExtemporaneusMulctAmmount, ResponseDate)
			VALUES (@IdOpaDetail, @TransactionNumber, @ErrorType, @ErrorMessage, @Cif, @CustomDuties, @Iva,
					@NationalizationMulct, @NationalizationMulctAmmount, @ExtemporaneusMulct,
					@ExtemporaneusMulctAmmount, @ResponseDate);
		END