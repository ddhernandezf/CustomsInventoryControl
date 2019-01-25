CREATE PROCEDURE [dbo].[spi_Phone]
	@Number			VARCHAR(15),
	@IdPerson		INT,
	@IdPhoneType	INT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	Phone
				 WHERE	IdPerson = @IdPerson
				   AND	UPPER(Number) = UPPER(@Number)))
		BEGIN
			RAISERROR (N'El numero %s ya se encuentra registrado para esta persona',16,1, @Number);
		END
	ELSE
		BEGIN
			INSERT INTO [Phone] (Number, IdPerson, IdPhoneType, RegisterDate, RegisterUser)
			VALUES (@Number, @IdPerson, @IdPhoneType, GETDATE(), @RegisterUser)
		END
