CREATE PROCEDURE [dbo].[spg_OpaResponse]
	@IdOpaDetial	INT
AS
	IF(ISNULL(@IdOpaDetial, 0) = 0)
		BEGIN
			SELECT	IdOpaDetail, TransactionNumber, ErrorType, ErrorMessage, Cif, CustomDuties, Iva,
					NationalizationMulct, NationalizationMulctAmmount, ExtemporaneusMulct,ExtemporaneusMulctAmmount, 
					ResponseDate
			  FROM	[OpaResponse]
		END
	ELSE
		BEGIN
			SELECT	IdOpaDetail, TransactionNumber, ErrorType, ErrorMessage, Cif, CustomDuties, Iva,
					NationalizationMulct, NationalizationMulctAmmount, ExtemporaneusMulct,ExtemporaneusMulctAmmount, 
					ResponseDate
			  FROM	[OpaResponse]
			 WHERE	IdOpaDetail = @IdOpaDetial
		END