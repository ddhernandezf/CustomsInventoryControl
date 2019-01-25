CREATE PROCEDURE [dbo].[spi_Resolution]
	@IdCustomer		INT, 
	@IdAccount		INT, 
	@Name			VARCHAR(100), 
	@Description	VARCHAR(1000), 
	@RateDate		DATETIME, 
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Resolution]
				 WHERE	IdCustomer = @IdCustomer
				   AND	IdAccount = @IdAccount
				   AND	UPPER(Name) = (@Name)))
		BEGIN
			RAISERROR (N'La resolución %s ya se encuentra registrada.',16,1, @Name);
		END
	ELSE
		BEGIN
			INSERT INTO [Resolution](IdCustomer, IdAccount, Name, [Description], RateDate, RegisterDate, RegisterUser)
			VALUES (@IdCustomer, @IdAccount, @Name, @Description, @RateDate, GETDATE(), @RegisterUser);
		END
