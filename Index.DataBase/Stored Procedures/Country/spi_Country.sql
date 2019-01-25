CREATE PROCEDURE [dbo].[spi_Country]
	@Name			VARCHAR(200),
	@IdParent		INT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Country]
				 WHERE	UPPER(Name) = UPPER(@Name)))
		BEGIN
			RAISERROR (N'El país %s ya se encuentra registrado.',16,1, @Name);
		END
	ELSE
		BEGIN
			INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser)
			VALUES(@Name, 0, GETDATE(), @RegisterUser);
		END
