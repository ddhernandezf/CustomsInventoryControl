CREATE PROCEDURE [spg_FileAttached]
	@IdFileHeader	INT
AS
	DECLARE @TempFileAttached TABLE (
		[Id] INT NOT NULL,
		[IdFileHeader] INT NOT NULL,
		[IdSupplier] INT NULL,
		[Description] VARCHAR(300) NULL,
		[AttachedNumber] VARCHAR(100) NULL,
		[AttachedDate] DATETIME  NULL
	)

	INSERT INTO @TempFileAttached(Id, IdFileHeader, IdSupplier, [Description], AttachedNumber, AttachedDate)
	SELECT	Id, IdFileHeader, IdSupplier, [Description], AttachedNumber, AttachedDate
	  FROM	[FileAttached]
	 WHERE	IdFileHeader = @IdFileHeader

	SELECT	fa.Id[IdFileAttached], fa.IdFileHeader, fa.IdSupplier, fa.[Description], fa.AttachedNumber, fa.AttachedDate,
			CASE WHEN p.IsEnterprise = 1 THEN
				p.EnterpriseName
			ELSE
				CASE WHEN p.LastName IS NULL THEN
					p.FirstName
				ELSE
					CONCAT(p.FirstName, ' ', p.LastName)
				END
			END [SupplierName]
	  FROM	@TempFileAttached fa LEFT OUTER JOIN [Supplier] s ON s.IdPerson = fa.IdSupplier
								 LEFT OUTER JOIN [Person] p ON p.Id = s.IdPerson
	 WHERE	fa.IdFileHeader = @IdFileHeader