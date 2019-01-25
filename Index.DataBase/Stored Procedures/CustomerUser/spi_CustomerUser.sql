CREATE PROCEDURE [dbo].[spi_CustomerUser]
	@IdCustomer		INT,
	@UserName		VARCHAR(60),
	@RegisterUser	VARCHAR(60)
AS
	INSERT INTO [CustomerUser](IdCustomer, UserName, RegisterDate, RegisterUser)
	VALUES(@IdCustomer, @UserName, GETDATE(), @RegisterUser);