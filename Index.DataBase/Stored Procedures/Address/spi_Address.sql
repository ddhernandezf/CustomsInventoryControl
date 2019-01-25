CREATE PROCEDURE [dbo].[spi_Address]
	@Address		VARCHAR(250),
	@IdPerson		INT,
	@IdAddressType	INT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Address]
				 WHERE	IdPerson = @IdPerson
				   AND	UPPER([Address]) = UPPER(@Address)))
		BEGIN
			RAISERROR (N'La dirección %s ya se encuentra registrado para esta persona',16,1, @Address);
		END
	ELSE
		BEGIN
			INSERT INTO [Address] ([Address], IdPerson, IdAddressType, RegisterDate, RegisterUser)
			VALUES (@Address, @IdPerson, @IdAddressType, GETDATE(), @RegisterUser)
		END
