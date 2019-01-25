CREATE PROCEDURE [dbo].[spg_FileDetailDisplay]
	@Id				INT,
	@IdFileInfoConfig	INT
AS
	IF(ISNULL(@Id, 0) = 0)
		BEGIN
			IF(ISNULL(@IdFileInfoConfig, 0) = 0)
				BEGIN
					SELECT	Id, IdFileInfoConfig, IdField, Label, IsUsed, IsRequeried
					  FROM	[FileDetailDisplay]
				END
			ELSE
				BEGIN
					SELECT	Id, IdFileInfoConfig, IdField, Label, IsUsed, IsRequeried
					  FROM	[FileDetailDisplay]
					 WHERE	IdFileInfoConfig = @IdFileInfoConfig
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdFileInfoConfig, 0) = 0)
				BEGIN
					SELECT	Id, IdFileInfoConfig, IdField, Label, IsUsed, IsRequeried
					  FROM	[FileDetailDisplay]
					 WHERE	Id = @Id
				END
			ELSE
				BEGIN
					SELECT	Id, IdFileInfoConfig, IdField, Label, IsUsed, IsRequeried
					  FROM	[FileDetailDisplay]
					 WHERE	IdFileInfoConfig = @IdFileInfoConfig
					   AND	Id = @Id
				END
		END