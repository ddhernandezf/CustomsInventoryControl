CREATE PROCEDURE [dbo].[spd_CustomerAccount]
	@IdCustomer		INT,
	@IdAccount		INT
AS
	DELETE FROM [CustomerAccount] WHERE IdCustomer = @IdCustomer AND IdAccount = @IdAccount;
