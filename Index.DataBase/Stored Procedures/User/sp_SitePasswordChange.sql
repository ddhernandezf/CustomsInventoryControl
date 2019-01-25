CREATE PROCEDURE [dbo].[sp_SitePasswordChange]
	@UserName	VARCHAR(60),
	@Password	VARCHAR(1000)
AS
	UPDATE	[User]
	   SET	SitePassword = @Password,
			PasswordReset = 0
	 WHERE	UserName = @UserName