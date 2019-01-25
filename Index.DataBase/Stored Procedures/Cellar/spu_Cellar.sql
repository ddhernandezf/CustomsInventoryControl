CREATE PROCEDURE [dbo].[spu_Cellar]
	@IdCellar			INT,
	@Name		VARCHAR(250),
	@Address	VARCHAR(300),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Cellar]
				 WHERE	UPPER(Name) = UPPER(@Name)
				   AND	Id <> @IdCellar))
		BEGIN
			RAISERROR (N'La bodega %s ya se encuentra registrada',16,1, @Name);
		END
	ELSE
		BEGIN
			UPDATE	[Cellar]
			   SET	Name = @Name, 
					[Address] = @Address,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @IdCellar;
		END
