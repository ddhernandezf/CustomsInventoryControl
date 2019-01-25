CREATE PROCEDURE [dbo].[spi_FileInfoConfig]
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
				   AND	IdAccount = @IdAccount))
		BEGIN
			RAISERROR (N'Esta configuración ya se encuentra registrada para este documento.',16,1);
		END
	ELSE
		BEGIN
			INSERT INTO [FileInfoConfig](IdFileInfo, IdFileType, IdAccount, UseAttached, IsSubstract, LoadRawMaterial, Transmissible, UseExpired, 
											RegisterDate,  RegisterUser, Active)
			VALUES(@IdFileInfo, @IdFileType, @IdAccount, @UseAttached, @IsSubstract, @LoadRawMaterial, @Transmissible, @UseExpired, 
					GETDATE(), @RegisterUser, @Active);
		END
