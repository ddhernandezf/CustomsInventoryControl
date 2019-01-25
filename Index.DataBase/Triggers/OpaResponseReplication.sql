CREATE TRIGGER [OpaResponseReplication]
	ON [dbo].[OpaResponse]
	FOR INSERT
	AS
	BEGIN
		SET NOCOUNT ON

		INSERT INTO OpaResponse_r(Id, IdOpaDetail, TransactionNumber, ErrorType, ErrorMessage, Cif, CustomDuties, Iva, NationalizationMulct, 
									NationalizationMulctAmmount, ExtemporaneusMulct, ExtemporaneusMulctAmmount, ResponseDate)
		SELECT	Id, IdOpaDetail, TransactionNumber, ErrorType, ErrorMessage, Cif, CustomDuties, Iva, NationalizationMulct, NationalizationMulctAmmount,
				ExtemporaneusMulct, ExtemporaneusMulctAmmount, ResponseDate
		  FROM	inserted
	END
