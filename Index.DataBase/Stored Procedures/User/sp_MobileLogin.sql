CREATE PROCEDURE [dbo].[sp_MobileLogin]
	@UserName	VARCHAR(60),
	@Password	VARCHAR(1000)
AS
	SELECT	u.IdPerson, p.FirstName, p.LastName, p.Nit,
			u.UserName, u.SitePassword, u.MobilePassword, u.RegisterDate, 
			u.LastTransactionDate, u.PasswordReset, u.OAuthSite, u.OAuthMobile,
			u.Active
	  FROM	[User] u INNER JOIN [Person] p ON p.Id = u.IdPerson
	 WHERE	u.OAuthMobile = 1
	   AND	u.UserName = @UserName
	   AND	u.MobilePassword = @Password;

	UPDATE	[User]
	   SET	LastTransactionDate = GETDATE()
	 WHERE	UserName = @UserName;
