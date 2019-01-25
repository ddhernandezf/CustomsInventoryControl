CREATE PROCEDURE [dbo].[spd_CustomerUser]
	@IdCustomer		INT
AS
	DELETE FROM [CustomerUser] WHERE IdCustomer = IdCustomer;
