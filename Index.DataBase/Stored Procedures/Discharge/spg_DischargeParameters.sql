CREATE PROCEDURE [dbo].[spg_DischargeParameters]
	@IdFileDetail INT
AS
	SELECT	fd.Id[IdFileDetail], fd.TransactionLine, fh.IdFileInfoConfig, fd.IdFileHeader, fh.IdDocument, 
			CONCAT(fi.[Name], ' (', ft.[Name], ')')[DocumentName], fh.IdCustomer,
			CASE WHEN p.EnterpriseName IS NULL
				THEN
					CASE WHEN p.LastName IS NULL
						THEN p.FirstName
						ELSE CONCAT(p.FirstName, ' ', p.LastName)
					END
				ELSE p.EnterpriseName
			END [CustomerName],
			ai.AccountingItem, fd.IdItem, i.Code, 
			CONCAT(i.[Name], ' (', um.Symbol, ')')[ItemName],
			a.Id[IdAccount], a.[Name][AccountName],
			CASE WHEN (SELECT count(*) FROM [Formula] f WHERE f.IdMainItem = fd.IdItem) > 0
				THEN CONVERT(BIT, 1)
				ELSE CONVERT(BIT, 0)
			END [UseFormula], fc.IsSubstract, fc.LoadRawMaterial
	  FROM	[FileDetail] fd INNER JOIN [Item] i ON i.Id = fd.IdItem
							INNER JOIN [FileHeader] fh ON fh.Id = fd.IdFileHeader
							INNER JOIN [FileInfoConfig] fc ON fc.Id = fh.IdFileInfoConfig
							INNER JOIN [FileInfo] fi ON fi.Id = fc.IdFileInfo
							INNER JOIN [FileInfoType] ft ON ft.Id = fc.IdFileType
							INNER JOIN [UnitMeasurement] um ON um.Id = i.IdUnitMeasurement
							INNER JOIN [AccountingItem] ai ON ai.Id = i.IdAccountingItem
							INNER JOIN [Account] a ON a.Id = fh.IdAccount
							INNER JOIN [Person] p ON p.Id = fh.IdCustomer
	 WHERE	fd.Id = @IdFileDetail