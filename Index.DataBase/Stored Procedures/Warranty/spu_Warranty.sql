CREATE PROCEDURE [dbo].[spu_Warranty]
	@Id				INT,
	@Name			VARCHAR(100),
	@Description	VARCHAR(1000),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Warranty]
				 WHERE	UPPER(Name) = UPPER(@Name)
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'La garantía %s ya se encuentra registrada.',16,1, @Name);
		END
	ELSE
		BEGIN
			UPDATE	[Warranty]
			   SET	Name = @Name,
					[Description] = @Description,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id;
		END