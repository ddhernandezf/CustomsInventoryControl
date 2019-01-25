CREATE PROCEDURE [dbo].[spd_CustomerUser2]
	@IdCustomer		INT,
	@UserName		VARCHAR(60)
AS
	DELETE FROM [CustomerUser] WHERE IdCustomer = IdCustomer AND UserName = @UserName;
