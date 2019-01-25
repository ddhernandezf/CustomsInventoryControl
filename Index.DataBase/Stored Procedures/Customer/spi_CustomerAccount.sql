CREATE PROCEDURE [dbo].[spi_CustomerAccount]
	@IdCustomer		INT,
	@IdAccount		INT,
	@RegisterUser	VARCHAR(60)
AS
	INSERT INTO [CustomerAccount](IdCustomer, IdAccount, RegisterDate, RegisterUser)
	VALUES (@IdCustomer, @IdAccount, GETDATE() ,@RegisterUser);