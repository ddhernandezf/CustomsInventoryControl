CREATE PROCEDURE [dbo].[spi_Cellar]
	@Name			VARCHAR(250),
	@Address		VARCHAR(300),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Cellar]
				 WHERE	UPPER(Name) = UPPER(@Name)))
		BEGIN
			RAISERROR (N'La bodega %s ya se encuentra registrada',16,1, @Name);
		END
	ELSE
		BEGIN
			INSERT INTO [Cellar](Name,[Address], RegisterDate, RegisterUser)
			VALUES(@Name, @Address, GETDATE(), @RegisterUser);
		END
