CREATE PROCEDURE [dbo].[spi_AssignUserToRole]
	@UserName		VARCHAR(60),
	@IdRole			INT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[UserRole]
				 WHERE	UserName = @UserName
				   AND	IdRole = @IdRole))
		BEGIN
			RAISERROR (N'Este rol ya se encuentra asignado al usuario %s',16,1, @UserName);
		END
	ELSE
		BEGIN
			INSERT INTO [UserRole] (UserName, IdRole, RegisterDate, RegisterUser)
			VALUES (@UserName, @IdRole, GETDATE(), @RegisterUser);
		END
