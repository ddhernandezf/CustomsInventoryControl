CREATE PROCEDURE [dbo].[spu_Address]
	@Id				INT,
	@Address		VARCHAR(250),
	@IdPerson		INT,
	@IdAddressType	INT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Address]
				 WHERE	IdPerson = @IdPerson
				   AND	UPPER([Address]) = UPPER(@Address)
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'La dirección %s ya se encuentra registrado para esta persona',16,1, @Address);
		END
	ELSE
		BEGIN
			UPDATE	[Address]
			   SET	[Address] = @Address, 
					IdPerson = @IdPerson, 
					IdAddressType = @IdAddressType,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id
		END
