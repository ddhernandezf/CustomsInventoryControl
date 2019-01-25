CREATE PROCEDURE [dbo].[spu_Currency]
	@Id				INT,
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
				   AND	UPPER(Name) = UPPER(@Name)
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'La moneda %s ya se encuentra registrada para este país.',16,1, @Name);
		END
	ELSE
		BEGIN
			UPDATE	[Currency]
			   SET	IdCountry = @IdCountry, 
					Name = @Name, 
					[Description] = @Description, 
					Symbol = @Symbol, 
					ExchangeRate = @ExchangeRate,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id;
		END
