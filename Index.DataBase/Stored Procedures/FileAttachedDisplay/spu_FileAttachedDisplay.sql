CREATE PROCEDURE [dbo].[spu_FileAttachedDisplay]
	@Id				INT,
	@IdFileInfoConfig	INT,
	@IdField		INT,
	@Label			VARCHAR(150),
	@IsUsed			BIT,
	@IsRequeried	BIT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[FileAttachedDisplay]
				 WHERE	IdField = @IdField
				   AND	IdFileInfoConfig = @IdFileInfoConfig
				   AND	Id <> @Id))
		BEGIN
			RAISERROR (N'Este campo ya fue registrado para este documento.',16,1);
		END
	ELSE
		BEGIN
			UPDATE	[FileAttachedDisplay]
			   SET	IdFileInfoConfig = @IdFileInfoConfig,
					IdField = @IdField,
					Label = @Label,
					IsUsed = @IsUsed,
					IsRequeried = @IsRequeried,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id;
		END