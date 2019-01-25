CREATE PROCEDURE [dbo].[spu_Customs]
	@IdCustom		INT,
	@IdCountry		INT,
	@Name			VARCHAR(250),
	@Address		VARCHAR(300),
	@Code			VARCHAR(10),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Customs]
				 WHERE	IdCountry = @IdCountry
				   AND	UPPER(Name) = UPPER(@Name)
				   AND	Id <> @IdCustom))
		BEGIN
			RAISERROR (N'La bodega %s ya se encuentra registrada para este país.',16,1, @Name);
		END
	ELSE
		BEGIN
			UPDATE	[Customs]
			   SET	IdCountry = @IdCountry, 
					Name = @Name, 
					[Address] = @Address,
					Code = @Code,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @IdCustom;
		END