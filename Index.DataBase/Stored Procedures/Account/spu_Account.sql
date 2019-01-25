CREATE PROCEDURE [dbo].[spu_Account]
	@Id				INT,
	@Name			VARCHAR(100),
	@Description	VARCHAR(1000),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Account]
				 WHERE	UPPER(Name) = UPPER(@Name)
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'La cuenta %s ya se encuentra registrada.',16,1, @Name);
		END
	ELSE
		BEGIN
			UPDATE	[Account]
			   SET	Name = @Name, 
					[Description] = @Description,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id;
		END