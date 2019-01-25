CREATE PROCEDURE [dbo].[spg_FilItemDischargeValidate]
	@IdFileItemDischarge	INT
AS
	DECLARE	@IdFileDetailImport	INT,
			@IdFileDetailExport	INT,
			@IdFileHeaderImport	INT,
			@IdFileHeaderExport	INT
	
	DECLARE @ResultTemp TABLE (
		[IsValid] BIT NULL,
		[ErrorMsg] VARCHAR(MAX) NULL
	)

	DECLARE @FileDetailImportTemp TABLE (
		[Id] INT NOT NULL,
		[IdFileHeader] INT NOT NULL,
		[IdState] INT NOT NULL,
		[TransactionLine] INT NULL,
		[IdItem] INT NOT NULL,
		[ItemQuantity] DECIMAL(18, 6) NULL,
		[CIFCotQuetzal] DECIMAL(18,6) NULL,
		[FOCostQuetzal] DECIMAL(18,6) NULL,
		[CIFCotDollar] DECIMAL(18,6) NULL,
		[FOCostDollar] DECIMAL(18,6) NULL,
		[CustomDuties] DECIMAL(18,6) NULL,
		[Iva] DECIMAL(18,6) NULL,
		[TaxableBase] DECIMAL(18,6) NULL,
		[TaxRate] DECIMAL(18,6) NULL,
		[NetWeight] DECIMAL(18,6) NULL,
		[GrossWeight] DECIMAL(18,6) NULL,
		[RegisterDate] DATETIME NULL,
		[RegisterUser] VARCHAR(60) NOT NULL
	)

	DECLARE @FileDetailExportTemp TABLE (
		[Id] INT NOT NULL,
		[IdFileHeader] INT NOT NULL,
		[IdState] INT NOT NULL,
		[TransactionLine] INT NULL,
		[IdItem] INT NOT NULL,
		[ItemQuantity] DECIMAL(18, 6) NULL,
		[CIFCotQuetzal] DECIMAL(18,6) NULL,
		[FOCostQuetzal] DECIMAL(18,6) NULL,
		[CIFCotDollar] DECIMAL(18,6) NULL,
		[FOCostDollar] DECIMAL(18,6) NULL,
		[CustomDuties] DECIMAL(18,6) NULL,
		[Iva] DECIMAL(18,6) NULL,
		[TaxableBase] DECIMAL(18,6) NULL,
		[TaxRate] DECIMAL(18,6) NULL,
		[NetWeight] DECIMAL(18,6) NULL,
		[GrossWeight] DECIMAL(18,6) NULL,
		[RegisterDate] DATETIME NULL,
		[RegisterUser] VARCHAR(60) NOT NULL
	)

	SELECT	@IdFileDetailImport = fid.IdFileDetailStock, @IdFileDetailExport = fid.IdFileDetailSubstract,
			@IdFileHeaderImport = fdi.IdFileHeader, @IdFileHeaderExport = fde.IdFileHeader
	  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fdi ON fdi.Id = fid.IdFileDetailStock
									INNER JOIN [FileDetail] fde ON fde.Id = fid.IdFileDetailSubstract
	 WHERE	fid.Id = @IdFileItemDischarge

	DECLARE	@SumCifImport			DECIMAL(18,6),
			@SumCifExport			DECIMAL(18,6),
			@CountLinesImport		INT,
			@CountLinesExport		INT,
			@TotalCifImport			DECIMAL(18,6),
			@TotalCifExport			DECIMAL(18,6),
			@TotalLinesImport		INT,
			@TotalLinesExport		INT,
			@FlagImportsError		VARCHAR(MAX),
			@FlagExportsError		VARCHAR(MAX),
			@DocumentNameImports	VARCHAR(MAX),
			@DocumentNameExports	VARCHAR(MAX)
	SET	@FlagImportsError = NULL
	SET	@FlagExportsError = NULL
	 
	SELECT	@SumCifImport = SUM(CIFCotQuetzal), @CountLinesImport = COUNT(*), 
			@TotalCifImport = fh.CIFTotal, @TotalLinesImport = fh.LinesTotal
	  FROM	FileDetail fdi INNER JOIN FileHeader fh ON fdi.IdFileHeader = fh.Id
	 WHERE	IdFileHeader = @IdFileHeaderImport
	 GROUP BY fh.CIFTotal, fh.LinesTotal

	--SELECT	@SumCifExport = SUM(CIFCotQuetzal), @CountLinesExport = COUNT(*), 
	--		@TotalCifExport = fh.CIFTotal, @TotalLinesExport = fh.LinesTotal
	--  FROM	FileDetail fde INNER JOIN FileHeader fh ON fde.IdFileHeader = fh.Id
	-- WHERE	IdFileHeader = @IdFileHeaderExport
	-- GROUP BY fh.CIFTotal, fh.LinesTotal

	SELECT	@DocumentNameImports = CONCAT(fi.Name, ' (' , ft.Name, ') ', fhi.IdDocument)
	  FROM	FileHeader fhi INNER JOIN FileInfoConfig fc ON fhi.IdFileInfoConfig = fc.Id
						   INNER JOIN FileInfo fi ON fc.IdFileInfo = fi.Id
						   INNER JOIN FileInfoType ft ON fc.IdFileType = ft.Id
	 WHERE	fhi.Id = @IdFileHeaderImport

	SELECT	@DocumentNameExports = CONCAT(fi.Name, ' (' , ft.Name, ') ', fhe.IdDocument)
	  FROM	FileHeader fhe INNER JOIN FileInfoConfig fc ON fhe.IdFileInfoConfig = fc.Id
						   INNER JOIN FileInfo fi ON fc.IdFileInfo = fi.Id
						   INNER JOIN FileInfoType ft ON fc.IdFileType = ft.Id
	 WHERE	fhE.Id = @IdFileHeaderExport

	IF(@SumCifImport != @TotalCifImport)
		 BEGIN
			DECLARE	@saldoResta DECIMAL(18, 6) = @TotalCifImport - @SumCifImport;
			IF(@saldoResta > 0.03)
				BEGIN
					SET @FlagImportsError = @DocumentNameImports + ' El valor CIF no concuerda con la sumatoria del detalle y el valor definido en el documento. El descuadres de ' + CONVERT(VARCHAR(50), @saldoResta) 
				END
		 END
	IF(@CountLinesImport != @TotalLinesImport)
		 BEGIN
			IF(@FlagImportsError IS NULL)
				BEGIN
					SET @FlagImportsError = @FlagImportsError + ', El total de líneas no concueda con la cantidad definida en el documento'
				END
			ELSE
				BEGIN
					SET @FlagImportsError = @DocumentNameImports + ' El total de líneas no concueda con la cantidad definida en el documento'
				END
		 END

	--IF(@SumCifExport != @TotalCifExport)
	--	 BEGIN
	--		SET @FlagExportsError = @DocumentNameExports + ' El valor CIF no concuerda con la sumatoria del detalle y el valor definido enel documento' 
	--	 END
	--IF(@CountLinesExport != @TotalLinesExport)
	--	 BEGIN
	--		IF(@FlagExportsError IS NULL)
	--			BEGIN
	--				SET @FlagExportsError = @FlagExportsError + ', El total de líneas no concueda con la cantidad definida en el documento'
	--			END
	--		ELSE
	--			BEGIN
	--				SET @FlagExportsError = @DocumentNameExports + ' El total de líneas no concueda con la cantidad definida en el documento'
	--			END
	--	 END

	INSERT INTO @ResultTemp(IsValid, ErrorMsg)
	SELECT	CASE WHEN @FlagExportsError IS NULL AND @FlagImportsError IS NULL
				THEN CONVERT(BIT, 1)
				ELSE CONVERT(BIT, 0)
			END[IsValid],
			CASE WHEN @FlagExportsError IS NOT NULL AND @FlagImportsError IS NOT NULL
				THEN CONCAT(@FlagExportsError, ' ', @FlagImportsError)
				ELSE 
					CASE WHEN @FlagExportsError IS NULL AND @FlagImportsError IS NULL
						THEN NULL
						ELSE
							CASE WHEN @FlagExportsError IS NOT NULL
								THEN @FlagExportsError
								ELSE @FlagImportsError
							END
					END
			END[ErrorMsg]

	SELECT	*
	  FROM	@ResultTemp