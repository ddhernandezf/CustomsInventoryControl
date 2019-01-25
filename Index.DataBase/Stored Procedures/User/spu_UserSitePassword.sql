CREATE PROCEDURE [dbo].[spu_UserSitePassword]
	@UserName VARCHAR(60),
	@Password	VARCHAR(100)
AS
	UPDATE	[User]
	   SET	SitePassword = @Password
	 WHERE	UserName = @UserName;

