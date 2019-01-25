CREATE PROCEDURE [dbo].[spu_CustomerUser]
	@IdCustomer		INT,
	@UserName		VARCHAR(60),
	@RegisterUser	VARCHAR(60)
AS
	UPDATE	[CustomerUser]
	   SET	UserName = @UserName,
			RegisterDate = GETDATE(),
			RegisterUser = @RegisterUser
	 WHERE	IdCustomer = @IdCustomer