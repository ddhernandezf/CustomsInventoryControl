CREATE PROCEDURE [dbo].[spi_Email]
	@Email			VARCHAR(300),
	@IdPerson		INT,
	@IdEmailType	INT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	Email
				 WHERE	IdPerson = @IdPerson
				   AND	UPPER(Email) = UPPER(@Email)))
		BEGIN
			RAISERROR (N'El email %s ya se encuentra registrado para esta persona',16,1, @Email);
		END
	ELSE
		BEGIN
			INSERT INTO [Email] (Email, IdPerson, IdEmailType, RegisterDate, RegisterUser)
			VALUES (@Email, @IdPerson, @IdEmailType, GETDATE(), @RegisterUser)
		END
