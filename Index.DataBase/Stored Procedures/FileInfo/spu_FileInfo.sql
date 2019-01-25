CREATE PROCEDURE [dbo].[spu_FileInfo]
	@IdFileInfo			INT,
	@Name				VARCHAR(100),
	@Description		VARCHAR(1000),
	@RegisterUser		VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[FileInfo]
				 WHERE	UPPER(Name) = UPPER(@Name)
				   AND	Id <> @IdFileInfo))
		BEGIN
			RAISERROR (N'El Documento %s ya se encuentra registrado.',16,1, @Name);
		END
	ELSE
		BEGIN
			UPDATE	[FileInfo]
			   SET	Name = @Name,
					[Description] = @Description,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @IdFileInfo;
		END
