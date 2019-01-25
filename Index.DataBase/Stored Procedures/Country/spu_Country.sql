CREATE PROCEDURE [dbo].[spu_Country]
	@IdCountry		INT,
	@Name			VARCHAR(200),
	@IdParent		INT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Country]
				 WHERE	UPPER(Name) = UPPER(@Name)
				   AND	Id <> @IdCountry))
		BEGIN
			RAISERROR (N'El país %s ya se encuentra registrado.',16,1, @Name);
		END
	ELSE
		BEGIN
			UPDATE	[Country]
			   SET	Name = @Name, 
					IdParent = 0,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @IdCountry;
		END