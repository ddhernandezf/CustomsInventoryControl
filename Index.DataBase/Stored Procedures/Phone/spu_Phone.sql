CREATE PROCEDURE [dbo].[spu_Phone]
	@Id				INT,
	@Number			VARCHAR(15),
	@IdPerson		INT,
	@IdPhoneType	INT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	Phone
				 WHERE	IdPerson = @IdPerson
				   AND	UPPER(Number) = UPPER(@Number)
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'El numero %s ya se encuentra registrado para esta persona',16,1, @Number);
		END
	ELSE
		BEGIN
			UPDATE	[Phone]
			   SET	Number = @Number, 
					IdPerson = @IdPerson, 
					IdPhoneType = @IdPhoneType,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id
		END
