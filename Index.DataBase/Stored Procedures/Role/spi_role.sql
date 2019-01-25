CREATE PROCEDURE [dbo].[spi_role]
	@Name			VARCHAR(100),
	@Description	VARCHAR(1000),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Role]
				 WHERE	UPPER(Name) = UPPER(@Name)))
		BEGIN
			RAISERROR (N'El rol %s ya se encuentra registrado.',16,1, @Name);
		END
	ELSE
		BEGIN
			INSERT INTO [Role] (Name, [Description], RegisterDate, RegisterUser)
			VALUES (@Name, @Description, GETDATE(), @RegisterUser);
		END