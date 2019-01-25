CREATE PROCEDURE [dbo].[spd_user]
	@UserName	VARCHAR(60)
AS
	DECLARE @IdPerson	INT
	SELECT @IdPerson = IdPerson FROM [User] WHERE UserName = @UserName;
	
	IF EXISTS (	SELECT	TOP 1 *
				  FROM	[FileHeader]
				 WHERE	RegisterUser = @UserName)
		BEGIN
			RAISERROR (N'El usuario %s posee movimientos dentro del sistema. Este usuario no puede ser eliminado.',16,1, @UserName);
		END
	ELSE IF EXISTS(	SELECT	TOP 1 *
					  FROM	[OpaHeader]
					 WHERE	RegisterUser = @UserName)
		BEGIN
			RAISERROR (N'El usuario %s posee movimientos dentro del sistema. Este usuario no puede ser eliminado.',16,1, @UserName);
		END
	ELSE
		BEGIN
			DELETE FROM [CustomerUser] WHERE UserName = @UserName;
			DELETE FROM [UserRole] WHERE UserName = @UserName;
			DELETE FROM [User] WHERE UserName = @UserName;
			DELETE FROM [Phone] WHERE IdPerson = @IdPerson;
			DELETE FROM [Email] WHERE IdPerson = @IdPerson;
			DELETE FROM [Address] WHERE IdPerson = @IdPerson;
			DELETE FROM [Person] WHERE Id = @IdPerson;
		END