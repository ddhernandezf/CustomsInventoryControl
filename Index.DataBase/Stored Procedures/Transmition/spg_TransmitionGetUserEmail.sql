CREATE PROCEDURE [dbo].[spg_TransmitionGetUserEmail]
	@UserName	VARCHAR(60)
AS
	DECLARE	@IdPremission	INT,
			@HasPremission	BIT,
			@Email			VARCHAR(300);
	SET @HasPremission = CONVERT(BIT, 0);

	SELECT @IdPremission = Id FROM Premission WHERE [Name] = 'Usuarios'

	IF EXISTS(	SELECT	* 
				  FROM	[RolePremission]
				 WHERE	IdRole IN (SELECT IdRole FROM [UserRole] WHERE UserName = @UserName)
				   AND	IdPremission = @IdPremission)
		BEGIN
			SET @HasPremission = CONVERT(BIT, 1);
		END

	SELECT	TOP 1 @Email = E.Email
	  FROM	[User] u LEFT OUTER JOIN [Email] e ON e.IdPerson = u.IdPerson
					 INNER JOIN [EmailType] et ON et.Id = e.IdEmailType
	 WHERE	u.UserName = @UserName
	   AND	et.[Description] = 'Trabajo';

	SELECT	@Email[Email], @HasPremission[HasPremission];