CREATE PROCEDURE [dbo].[sp_MobilePasswordReset]
	@UserName	VARCHAR(60),
	@Password	VARCHAR(1000)
AS
	UPDATE	[User]
	   SET	MobilePassword = @Password,
			PasswordReset = 0
	 WHERE	UserName = @UserName
