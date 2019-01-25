CREATE PROCEDURE [dbo].[spi_FileDetailDisplay]
	@IdFileInfoConfig	INT,
	@IdField		INT,
	@Label			VARCHAR(150),
	@IsUsed			BIT,
	@IsRequeried	BIT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[FileDetailDisplay]
				 WHERE	IdField = @IdField
				   AND	IdFileInfoConfig = @IdFileInfoConfig))
		BEGIN
			RAISERROR (N'Este campo ya fue registrado para este documento.',16,1);
		END
	ELSE
		BEGIN
			INSERT INTO [FileDetailDisplay](IdFileInfoConfig, IdField, Label, IsUsed, IsRequeried, RegisterDate, RegisterUser)
			VALUES (@IdFileInfoConfig, @IdField, @Label, @IsUsed, @IsRequeried, GETDATE(), @RegisterUser);
		END
