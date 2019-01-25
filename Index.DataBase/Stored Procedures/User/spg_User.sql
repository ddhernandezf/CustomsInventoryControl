CREATE PROCEDURE [dbo].[spg_User]
	@UserName	VARCHAR(60)
AS
	IF(ISNULL(@UserName, '') = '')
		BEGIN
			SELECT	u.IdPerson, p.FirstName, p.LastName, p.Nit,
					u.UserName, u.SitePassword, u.MobilePassword, u.RegisterDate, 
					u.LastTransactionDate, u.PasswordReset, u.OAuthSite, u.OAuthMobile,
					u.Active
			 FROM	[User] u INNER JOIN [Person] p ON p.Id = u.IdPerson
		END
	ELSE
		BEGIN
			SELECT	u.IdPerson, p.FirstName, p.LastName, p.Nit,
					u.UserName, u.SitePassword, u.MobilePassword, u.RegisterDate, 
					u.LastTransactionDate, u.PasswordReset, u.OAuthSite, u.OAuthMobile,
					u.Active
			  FROM	[User] u INNER JOIN [Person] p ON p.Id = u.IdPerson
			 WHERE	u.UserName = @UserName
		END