CREATE PROCEDURE [dbo].[spu_role]
	@Id				INT,
	@Name			VARCHAR(100),
	@Description	VARCHAR(1000),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Role]
				 WHERE	UPPER(Name) = UPPER(@Name)
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'El rol %s ya se encuentra registrado.',16,1, @Name);
		END
	ELSE
		BEGIN
			UPDATE	[Role]
			   SET	Name = @Name, 
					[Description] = @Description,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id
		END