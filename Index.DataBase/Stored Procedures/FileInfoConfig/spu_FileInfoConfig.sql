CREATE PROCEDURE [dbo].[spu_FileInfoConfig]
	@IdFileInfoConfig	INT,
	@IdFileInfo			INT,
	@IdFileType			INT,
	@IdAccount			INT,
	@UseAttached		BIT,
	@IsSubstract		BIT,
	@LoadRawMaterial	BIT,
	@Transmissible		BIT,
	@UseExpired			BIT,
	@Active				BIT,
	@RegisterUser		VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[FileInfoConfig]
				 WHERE	IdFileInfo = @IdFileInfo
				   AND	IdFileType = @IdFileType
				   AND	IdAccount = @IdAccount
				   AND	Id <> @IdFileInfoConfig))
		BEGIN
			RAISERROR (N'Esta configuración ya se encuentra registrada para este documento.',16,1);
		END
	ELSE
		BEGIN
			UPDATE	[FileInfoConfig]
			   SET	IdFileInfo = @IdFileInfo, 
					IdFileType = @IdFileType, 
					IdAccount = @IdAccount, 
					UseAttached = @UseAttached, 
					IsSubstract = @IsSubstract,
					LoadRawMaterial = @LoadRawMaterial,
					Transmissible = @Transmissible,
					UseExpired = @UseExpired,
					RegisterDate = GETDATE(), 
					RegisterUser = @RegisterUser,
					Active = @Active
			 WHERE	Id = @IdFileInfoConfig;
		END
