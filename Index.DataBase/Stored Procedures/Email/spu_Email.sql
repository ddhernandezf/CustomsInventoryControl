CREATE PROCEDURE [dbo].[spu_Email]
	@Id				INT,
	@Email			VARCHAR(300),
	@IdPerson		INT,
	@IdPhoneType	INT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	Email
				 WHERE	IdPerson = @IdPerson
				   AND	UPPER(Email) = UPPER(@Email)
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'El email %s ya se encuentra registrado para esta persona',16,1, @Email);
		END
	ELSE
		BEGIN
			UPDATE	[Email]
			   SET	Email = @Email, 
					IdPerson = @IdPerson, 
					IdEmailType = @IdPhoneType,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id;
		END
