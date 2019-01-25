CREATE PROCEDURE [dbo].[spg_FileDetailValidateToDischarge]
	@IdFileDetail	INT
AS
	DECLARE	@IdFileHeader	INT,
			@CifTotal		DECIMAL(18,6),
			@LinesTotal		DECIMAL(18,6),
			@SumCifTotal		DECIMAL(18,6),
			@SumLinesTotal		DECIMAL(18,6)

	DECLARE @FileDetailTemp TABLE (
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

	SELECT	@IdFileHeader = fd.IdFileHeader, @CifTotal = fh.CIFTotal, @LinesTotal = fh.LinesTotal
	  FROM	[FileDetail] fd INNER JOIN [FileHeader] fh ON fh.Id = fd.IdFileHeader
	 WHERE	fd.Id = @IdFileDetail

	INSERT INTO @FileDetailTemp
	SELECT	*
	  FROM	[FileDetail]
	 WHERE IdFileHeader = @IdFileHeader

	SELECT	@SumCifTotal = SUM(CIFCotQuetzal), @SumLinesTotal = COUNT(*)
	  FROM	@FileDetailTemp

	SELECT	CASE WHEN @CifTotal = @SumCifTotal AND @LinesTotal = @SumLinesTotal
				THEN CONVERT(BIT, 1)
				ELSE CONVERT(BIT, 0)
			END [IsValid]