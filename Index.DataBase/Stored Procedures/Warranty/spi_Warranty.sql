CREATE PROCEDURE [dbo].[spi_Warranty]
	@Name			VARCHAR(100),
	@Description	VARCHAR(1000),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Warranty]
				 WHERE	UPPER(Name) = UPPER(@Name)))
		BEGIN
			RAISERROR (N'La garantía %s ya se encuentra registrada.',16,1, @Name);
		END
	ELSE
		BEGIN
			INSERT INTO [Warranty](Name, [Description], RegisterDate, RegisterUser)
			VALUES (@Name, @Description, GETDATE(), @RegisterUser);
		END
