CREATE PROCEDURE [dbo].[spi_User]
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
	DECLARE	@LastTransactionDate	DATETIME,
			@IdPerson				INT;

	SELECT @LastTransactionDate = GETDATE();
	EXEC spi_Person @FirstName,@LastName,@Nit,@IdPerson OUT, @RegisterUser;

	IF(EXISTS(	SELECT	*
				  FROM	[User]
				 WHERE	UPPER(UserName) = UPPER(@UserName)))
	BEGIN
		RAISERROR (N'El usuario %s ya se encuentra en uso.',16,1, @UserName);
	END
	ELSE IF(EXISTS(	SELECT	*
					  FROM	[User]
					 WHERE	IdPerson = @IdPerson))
	BEGIN
		RAISERROR (N'La persona %s ya tiene un usuario asignado.',16,1, @FirstName);
	END
	ELSE
	BEGIN
		INSERT INTO [User](UserName, IdPerson, SitePassword, MobilePassword, LastTransactionDate,
							PasswordReset, OAuthSite, OAuthMobile, Active, RegisterDate, RegisterUser)
		VALUES (@UserName, @IdPerson, @SitePassword, @MobilePassword, @LastTransactionDate,
				@PasswordReset, @OAuthSite, @OAuthMobile, @Active, GETDATE(), @RegisterUser);
	END