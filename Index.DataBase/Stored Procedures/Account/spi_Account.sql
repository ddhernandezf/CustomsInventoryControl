CREATE PROCEDURE [dbo].[spi_Account]
	@Name			VARCHAR(100),
	@Description	VARCHAR(1000),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Account]
				 WHERE	UPPER(Name) = UPPER(@Name)))
		BEGIN
			RAISERROR (N'La cuenta %s ya se encuentra registrada.',16,1, @Name);
		END
	ELSE
		BEGIN
			INSERT INTO [Account] (Name, [Description], RegisterDate, RegisterUser)
			VALUES (@Name, @Description, GETDATE(), @RegisterUser);
		END