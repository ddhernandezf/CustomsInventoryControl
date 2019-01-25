CREATE PROCEDURE [dbo].[spu_User]
	@IdPerson				INT,
	@FirstName		VARCHAR(150),
	@LastName		VARCHAR(150),
	@Nit			VARCHAR(15),
	@UserName		VARCHAR(60),
	@SitePassword	VARCHAR(1000),
	@MobilePassword	VARCHAR(1000),
	@PasswordReset	BIT,
	@OAuthSite		BIT,
	@OAuthMobile	BIT,
	@Active			BIT,
	@RegisterUser	VARCHAR(60)
AS
	DECLARE	@LastTransactionDate	DATETIME;
	
	SELECT @LastTransactionDate = GETDATE();
	EXEC spu_Person @IdPerson, @FirstName, @LastName, @Nit, @RegisterUser;

	UPDATE	[User]
	   SET	SitePassword = @SitePassword, 
			MobilePassword = @MobilePassword, 
			LastTransactionDate = @LastTransactionDate, 
			PasswordReset = @PasswordReset, 
			OAuthSite = @OAuthSite, 
			OAuthMobile = @OAuthMobile, 
			Active = @Active,
			RegisterDate = GETDATE(),
			RegisterUser = @RegisterUser
	 WHERE	UserName = @UserName