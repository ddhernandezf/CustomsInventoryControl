CREATE PROCEDURE [dbo].[spg_FileAttachedDisplay]
	@Id				INT,
	@IdFileConfig	INT
AS
	IF(ISNULL(@Id, 0) = 0)
		BEGIN
			IF(ISNULL(@IdFileConfig, 0) = 0)
				BEGIN
					SELECT	Id, IdFileInfoConfig, IdField, Label, IsUsed, IsRequeried
					  FROM	[FileAttachedDisplay]
				END
			ELSE
				BEGIN
					SELECT	Id, IdFileInfoConfig, IdField, Label, IsUsed, IsRequeried
					  FROM	[FileAttachedDisplay]
					 WHERE	IdFileInfoConfig = @IdFileConfig
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdFileConfig, 0) = 0)
				BEGIN
					SELECT	Id, IdFileInfoConfig, IdField, Label, IsUsed, IsRequeried
					  FROM	[FileAttachedDisplay]
					 WHERE	Id = @Id
				END
			ELSE
				BEGIN
					SELECT	Id, IdFileInfoConfig, IdField, Label, IsUsed, IsRequeried
					  FROM	[FileAttachedDisplay]
					 WHERE	IdFileInfoConfig = @IdFileConfig
					   AND	Id = @Id
				END
		END