CREATE PROCEDURE [dbo].[spu_Resolution]
	@Id				INT,
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
				   AND	UPPER(Name) = (@Name)
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'La resolución %s ya se encuentra registrada.',16,1, @Name);
		END
	ELSE
		BEGIN
			UPDATE	[Resolution]
			   SET	IdCustomer = @IdCustomer,
					IdAccount = @IdAccount,
					Name = @Name,
					[Description] = @Description,
					RateDate = @RateDate,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id;
		END