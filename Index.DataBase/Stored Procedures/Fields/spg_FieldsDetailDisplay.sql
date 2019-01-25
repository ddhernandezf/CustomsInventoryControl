CREATE PROCEDURE [dbo].[spg_FieldsDetailDisplay]
	@IdFileInfoConfig INT
AS
	DECLARE	@IdTable INT
	SET @IdTable = 2

	DECLARE @TempTable TABLE (
		[IdField] INT NOT NULL,
		[IdTable] INT NOT NULL,
		[TableName] VARCHAR(100) NOT NULL,
		[FieldName] VARCHAR(150) NOT NULL,
		[DataBaseName] VARCHAR(150) NOT NULL,
		[ObjectHtml] VARCHAR(150) NOT NULL,
		[IsRequiredInternal] BIT NOT NULL,
		[IdFileInfoConfig] INT NOT NULL,
		[IdMaster] INT NOT NULL,
		[Label] VARCHAR(150) NULL,
		[IsUsed] BIT NOT NULL,
		[IsRequeried] BIT NOT NULL
	)

	INSERT INTO	@TempTable([IdField], [IdTable], [TableName], [FieldName], [DataBaseName], [ObjectHtml], [IsRequiredInternal],
							[IdFileInfoConfig], [IdMaster], [Label], [IsUsed], [IsRequeried])
	SELECT	f.Id, f.IdTable, t.Name[TableName], f.name[FieldName], f.DataBaseName, f.HtmlObject, f.IsRequired[IsRequiredInternal], 
			fm.IdFileInfoConfig, fm.Id[IdMaster], fm.Label, fm.IsUsed, fm.IsRequeried
	  FROM	[Table] t INNER JOIN [Fields] f ON t.Id = f.IdTable
					  right JOIN [FileDetailDisplay] fm ON fm.IdField = f.Id
	 WHERE	t.id = @IdTable
	   AND	fm.IdFileInfoConfig = @IdFileInfoConfig

	INSERT INTO	@TempTable([IdField], [IdTable], [TableName], [FieldName], [DataBaseName], [ObjectHtml], [IsRequiredInternal],
							[IdFileInfoConfig], [IdMaster], [Label], [IsUsed], [IsRequeried])
	SELECT	f.Id, f.IdTable, t.Name[TableName], f.name[FieldName], f.DataBaseName, f.HtmlObject, f.IsRequired[IsRequiredInternal], 
			@IdFileInfoConfig[IdFileConfig], 0[IdMaster], null[Label], f.IsRequired[IsUsed], f.IsRequired[IsRequired] 
	  FROM	[Table] t INNER JOIN [Fields] f ON t.Id = f.IdTable
	 WHERE	t.id = @IdTable
	   AND	f.id NOT IN (SELECT [IdField] FROM @TempTable)

	SELECT	IdField, IdTable, TableName, FieldName, DataBaseName, ObjectHtml, IsRequiredInternal, IdFileInfoConfig, IdMaster, 
			Label, IsUsed, IsRequeried
	  FROM	@TempTable