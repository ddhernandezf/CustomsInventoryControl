CREATE PROCEDURE [dbo].[spi_Customs]
	@IdCountry		INT,
	@Name			VARCHAR(250),
	@Address		VARCHAR(300),
	@Code			VARCHAR(10),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Customs]
				 WHERE	IdCountry = @IdCountry
				   AND	UPPER(Name) = UPPER(@Name)))
		BEGIN
			RAISERROR (N'La bodega %s ya se encuentra registrada para este país.',16,1, @Name);
		END
	ELSE
		BEGIN
			INSERT INTO [Customs](IdCountry, Name, [Address], Code, RegisterDate, RegisterUser)
			VALUES(@IdCountry, @Name, @Address, @Code, GETDATE(), @RegisterUser);
		END
