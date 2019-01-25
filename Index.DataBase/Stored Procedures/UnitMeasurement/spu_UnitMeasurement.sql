CREATE PROCEDURE [dbo].[spu_UnitMeasurement]
	@Id				INT,
	@Name			VARCHAR(150), 
	@Description	VARCHAR(1000),
	@Symbol			VARCHAR(4),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[UnitMeasurement]
				 WHERE	UPPER(Name) = UPPER(@Name)
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'La unidad de medida %s ya se encuentra registrada.',16,1, @Name);
		END
	ELSE
		BEGIN
			UPDATE	[UnitMeasurement]
			   SET	Name = @Name, 
					[Description] = @Description, 
					Symbol = @Symbol,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id;
		END
