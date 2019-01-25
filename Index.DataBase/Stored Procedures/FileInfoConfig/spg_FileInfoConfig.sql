CREATE PROCEDURE [dbo].[spg_FileInfoConfig]
	@IdFileInfoConfig	INT,
	@IdFileInfo			INT,
	@IdAccount			INT
AS
	IF(ISNULL(@IdFileInfoConfig, 0) = 0)
		BEGIN
			IF(ISNULL(@IdFileInfo, 0) = 0)
				BEGIN
					IF(ISNULL(@IdAccount, 0) = 0)
						BEGIN
							SELECT	fc.Id[IdFileInfoConfig], fi.Id[IdFileInfo], fi.[Name][FileInfoName], 
									fc.IdFileType, ft.[Name][FileTypeName], fc.IdAccount, a.[Name][AccountName],
									fc.UseAttached, fc.IsSubstract, fc.LoadRawMaterial, fc.Transmissible, fc.UseExpired,
									CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownListName], fc.Active
							  FROM	[FileInfo] fi INNER JOIN [FileInfoConfig] fc ON fi.Id = fc.IdFileInfo
												  INNER JOIN [FileInfoType] ft ON fc.IdFileType = ft.Id
												  INNER JOIN [Account] a ON a.Id = fc.IdAccount
						END
					ELSE
						BEGIN
							SELECT	fc.Id[IdFileInfoConfig], fi.Id[IdFileInfo], fi.[Name][FileInfoName], 
									fc.IdFileType, ft.[Name][FileTypeName], fc.IdAccount, a.[Name][AccountName],
									fc.UseAttached, fc.IsSubstract, fc.LoadRawMaterial, fc.Transmissible, fc.UseExpired,
									CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownListName], fc.Active
							  FROM	[FileInfo] fi INNER JOIN [FileInfoConfig] fc ON fi.Id = fc.IdFileInfo
												  INNER JOIN [FileInfoType] ft ON fc.IdFileType = ft.Id
												  INNER JOIN [Account] a ON a.Id = fc.IdAccount
							 WHERE	fc.IdAccount = @IdAccount
						END
				END
			ELSE
				BEGIN
					IF(ISNULL(@IdAccount, 0) = 0)
						BEGIN
							SELECT	fc.Id[IdFileInfoConfig], fi.Id[IdFileInfo], fi.[Name][FileInfoName], 
									fc.IdFileType, ft.[Name][FileTypeName], fc.IdAccount, a.[Name][AccountName],
									fc.UseAttached, fc.IsSubstract, fc.LoadRawMaterial, fc.Transmissible, fc.UseExpired,
									CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownListName], fc.Active
							  FROM	[FileInfo] fi INNER JOIN [FileInfoConfig] fc ON fi.Id = fc.IdFileInfo
												  INNER JOIN [FileInfoType] ft ON fc.IdFileType = ft.Id
												  INNER JOIN [Account] a ON a.Id = fc.IdAccount
							 WHERE	fi.Id = @IdFileInfo
						END
					ELSE
						BEGIN
							SELECT	fc.Id[IdFileInfoConfig], fi.Id[IdFileInfo], fi.[Name][FileInfoName], 
									fc.IdFileType, ft.[Name][FileTypeName], fc.IdAccount, a.[Name][AccountName],
									fc.UseAttached, fc.IsSubstract, fc.LoadRawMaterial, fc.Transmissible, fc.UseExpired,
									CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownListName], fc.Active
							  FROM	[FileInfo] fi INNER JOIN [FileInfoConfig] fc ON fi.Id = fc.IdFileInfo
												  INNER JOIN [FileInfoType] ft ON fc.IdFileType = ft.Id
												  INNER JOIN [Account] a ON a.Id = fc.IdAccount
							 WHERE	fi.Id = @IdFileInfo
							   AND	fc.IdAccount = @IdAccount
						END
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdFileInfo, 0) = 0)
				BEGIN
					IF(ISNULL(@IdAccount, 0) = 0)
						BEGIN
							SELECT	fc.Id[IdFileInfoConfig], fi.Id[IdFileInfo], fi.[Name][FileInfoName], 
									fc.IdFileType, ft.[Name][FileTypeName], fc.IdAccount, a.[Name][AccountName],
									fc.UseAttached, fc.IsSubstract, fc.LoadRawMaterial, fc.Transmissible, fc.UseExpired,
									CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownListName], fc.Active
							  FROM	[FileInfo] fi INNER JOIN [FileInfoConfig] fc ON fi.Id = fc.IdFileInfo
												  INNER JOIN [FileInfoType] ft ON fc.IdFileType = ft.Id
												  INNER JOIN [Account] a ON a.Id = fc.IdAccount
							 WHERE	fc.Id = @IdFileInfoConfig
						END
					ELSE
						BEGIN
							SELECT	fc.Id[IdFileInfoConfig], fi.Id[IdFileInfo], fi.[Name][FileInfoName], 
									fc.IdFileType, ft.[Name][FileTypeName], fc.IdAccount, a.[Name][AccountName],
									fc.UseAttached, fc.IsSubstract, fc.LoadRawMaterial, fc.Transmissible, fc.UseExpired,
									CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownListName], fc.Active
							  FROM	[FileInfo] fi INNER JOIN [FileInfoConfig] fc ON fi.Id = fc.IdFileInfo
												  INNER JOIN [FileInfoType] ft ON fc.IdFileType = ft.Id
												  INNER JOIN [Account] a ON a.Id = fc.IdAccount
							 WHERE	fc.Id = @IdFileInfoConfig
							   AND	fc.IdAccount = @IdAccount
						END
				END
			ELSE
				BEGIN
					IF(ISNULL(@IdAccount, 0) = 0)
						BEGIN
							SELECT	fc.Id[IdFileInfoConfig], fi.Id[IdFileInfo], fi.[Name][FileInfoName], 
									fc.IdFileType, ft.[Name][FileTypeName], fc.IdAccount, a.[Name][AccountName],
									fc.UseAttached, fc.IsSubstract, fc.LoadRawMaterial, fc.Transmissible, fc.UseExpired,
									CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownListName], fc.Active
							  FROM	[FileInfo] fi INNER JOIN [FileInfoConfig] fc ON fi.Id = fc.IdFileInfo
												  INNER JOIN [FileInfoType] ft ON fc.IdFileType = ft.Id
												  INNER JOIN [Account] a ON a.Id = fc.IdAccount
							 WHERE	fc.Id = @IdFileInfoConfig
							   AND	fi.Id = @IdFileInfo
						END
					ELSE
						BEGIN
							SELECT	fc.Id[IdFileInfoConfig], fi.Id[IdFileInfo], fi.[Name][FileInfoName], 
									fc.IdFileType, ft.[Name][FileTypeName], fc.IdAccount, a.[Name][AccountName],
									fc.UseAttached, fc.IsSubstract, fc.LoadRawMaterial, fc.Transmissible, fc.UseExpired,
									CONCAT(fi.[Name], ' (', ft.[Name], ')')[DropDownListName], fc.Active
							  FROM	[FileInfo] fi INNER JOIN [FileInfoConfig] fc ON fi.Id = fc.IdFileInfo
												  INNER JOIN [FileInfoType] ft ON fc.IdFileType = ft.Id
												  INNER JOIN [Account] a ON a.Id = fc.IdAccount
							 WHERE	fc.Id = @IdFileInfoConfig
							   AND	fi.Id = @IdFileInfo
							   AND	fc.IdAccount = @IdAccount
						END
				END
		END
