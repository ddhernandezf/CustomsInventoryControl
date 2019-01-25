CREATE PROCEDURE [dbo].[spi_Currency]
	@IdCountry		INT,
	@Name			VARCHAR(100),
	@Description	VARCHAR(1000),
	@Symbol			VARCHAR(4),
	@ExchangeRate	DECIMAL(10,2),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Currency]
				 WHERE	IdCountry = @IdCountry
				   AND	UPPER(Name) = UPPER(@Name)))
			BEGIN
				RAISERROR (N'La moneda %s ya se encuentra registrada para este país.',16,1, @Name);
			END
	ELSE
		BEGIN
			INSERT INTO [Currency](IdCountry, Name, [Description], Symbol, ExchangeRate, RegisterDate, RegisterUser)
			VALUES(@IdCountry, @Name, @Description, @Symbol, @ExchangeRate, GETDATE(), @RegisterUser);
		END