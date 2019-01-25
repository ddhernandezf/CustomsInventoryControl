CREATE PROCEDURE [dbo].[spg_Item]
	@IdCustomer	INT,
	@IdAccount	INT,
	@IdItem		INT,
	@IsProduct	BIT
AS
	DECLARE @ItemTemp TABLE (
		[Id] INT NOT NULL,
		[IdCustomer] INT NOT NULL,
		[IdResolution] INT NULL,
		[IdAccountingItem] INT NULL,
		[IdUnitMeasurement] INT NOT NULL,
		[Code] NVARCHAR(50) NOT NULL,
		[Name] VARCHAR(200) NOT NULL,
		[Description] VARCHAR(1000) NULL,
		[Barcode] NVARCHAR(100) NULL,
		[IsProduct] BIT NOT NULL,
		[RegisterDate] DATETIME NOT NULL,
		[RegisterUser] VARCHAR(60) NOT NULL,
		[Active] BIT NOT NULL
	)

	IF(ISNULL(@IdItem,0) = 0)
		BEGIN
			INSERT INTO @ItemTemp(Id, IdCustomer, IdResolution, IdAccountingItem, IdUnitMeasurement, Code, Name, Description, Barcode,
									IsProduct, RegisterDate, RegisterUser, Active)
			SELECT	Id, IdCustomer, IdResolution, IdAccountingItem, IdUnitMeasurement, Code, Name, Description, Barcode, IsProduct, RegisterDate,
					RegisterUser, Active
			  FROM	[Item]
			 WHERE	IdCustomer = @IdCustomer
			   AND	IdAccount = @IdAccount
			   AND	IsProduct = @IsProduct
		END
	ELSE
		BEGIN
			INSERT INTO @ItemTemp(Id, IdCustomer, IdResolution, IdAccountingItem, IdUnitMeasurement, Code, Name, Description, Barcode,
									IsProduct, RegisterDate, RegisterUser, Active)
			SELECT	Id, IdCustomer, IdResolution, IdAccountingItem, IdUnitMeasurement, Code, Name, Description, Barcode, IsProduct, RegisterDate,
					RegisterUser, Active
			  FROM	[Item]
			 WHERE	IdCustomer = @IdCustomer
			   AND	IdAccount = @IdAccount
			   AND	IsProduct = @IsProduct
			   AND	Id = @IdItem
		END

	SELECT	p.Id, p.IdCustomer, p.IdResolution, p.IdAccountingItem, p.IdUnitMeasurement,
			p.Code, p.Barcode, p.[Name], p.[Description], p.IsProduct, um.[Name][UnitMeasurementName],
			um.Symbol[UnitMeasurementSymbol], ai.AccountingItem, aip.Parent, aip.[Description][ParentName],
			CONCAT(p.Code, ' - ', p.[Name], ' (', um.Symbol, ')')[DisplayProductName],
			ai.[Description][AccountingItemName], CONCAT(ai.AccountingItem, ' - ', ai.[Description])[DisplayAccountingItem],
			CASE WHEN COUNT(f.Id) > 0
				THEN CONVERT(BIT, 1) 
				ELSE CONVERT(BIT, 0)
			END[HasFormula], p.Active
	  FROM	@ItemTemp p LEFT OUTER JOIN Resolution r ON r.Id = p.IdResolution
							 LEFT OUTER JOIN AccountingItem ai ON ai.Id = p.IdAccountingItem
							 INNER JOIN UnitMeasurement um ON um.Id = p.IdUnitMeasurement
							 LEFT OUTER JOIN  AccountingItem aip ON aip.AccountingItem = ai.Parent
							 LEFT OUTER JOIN Formula  f ON f.IdMainItem = p.Id
	GROUP BY	p.Id, p.IdCustomer, p.IdResolution, p.IdAccountingItem, p.IdUnitMeasurement,
				p.Code, p.Barcode, p.[Name], p.[Description], p.IsProduct, um.[Name],
						um.Symbol, ai.AccountingItem, aip.Parent, aip.[Description],
						CONCAT(p.Code, ' - ', p.[Name], ' (', ai.AccountingItem, ')'),
						ai.[Description], CONCAT(ai.AccountingItem, ' - ', ai.[Description]), p.Active
	 ORDER BY p.Name;