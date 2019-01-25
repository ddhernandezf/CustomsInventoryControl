CREATE PROCEDURE [dbo].[spg_Formula]
	@IdFormula	INT,
	@IdCustomer	INT,
	@IdMainItem	INT
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
		[RegisterUser] VARCHAR(60) NOT NULL
	)

	DECLARE @FormulaTemp TABLE (
		[Id] INT NOT NULL,
		[IdMainItem] INT NOT NULL,
		[IdDetailItem] INT NOT NULL,
		[Quantity] DECIMAL(18,6) NOT NULL,
		[Decrease] DECIMAL(18,6) NOT NULL,
		[RegisterDate] DATETIME NOT NULL,
		[RegisterUser] VARCHAR(60) NOT NULL,
		[Active] BIT NOT NULL
	)

	INSERT INTO @ItemTemp(Id, IdCustomer, IdResolution, IdAccountingItem, IdUnitMeasurement, Code, Name, Description, Barcode,
							IsProduct, RegisterDate, RegisterUser)
	SELECT	Id, IdCustomer, IdResolution, IdAccountingItem, IdUnitMeasurement, Code, Name, Description, Barcode, IsProduct, RegisterDate,
			RegisterUser
	  FROM	[Item]
	 WHERE	IdCustomer = @IdCustomer

	IF(ISNULL(@IdFormula, 0) = 0)
		BEGIN
			INSERT INTO @FormulaTemp(Id, IdMainItem, IdDetailItem, Quantity, Decrease, RegisterDate, RegisterUser, Active)
			SELECT	Id, IdMainItem, IdDetailItem, Quantity, Decrease, RegisterDate, RegisterUser, Active
			  FROM	[Formula]
			 WHERE	IdMainItem = @IdMainItem
		END
	ELSE
		BEGIN
			INSERT INTO @FormulaTemp(Id, IdMainItem, IdDetailItem, Quantity, Decrease, RegisterDate, RegisterUser, Active)
			SELECT	Id, IdMainItem, IdDetailItem, Quantity, Decrease, RegisterDate, RegisterUser, Active
			  FROM	[Formula]
			 WHERE	IdMainItem = @IdMainItem
			   AND	Id = @IdFormula
		END

	SELECT	f.Id, f.IdMainItem, im.Name[MainItem], f.IdDetailItem, id.Name[DetailItem],
			CONCAT(id.Code, ' - ', id.Name, ' (', um.Symbol, ')')[DisplayDetailItem],
			ai.AccountingItem[DetailAccountingItem],
			CONCAT(ai.AccountingItem, ' - ', ai.Description)[DisplauDetailAccountingItem],
			f.Quantity, f.Decrease, im.IdCustomer, f.Active
	  FROM	@FormulaTemp f INNER JOIN @ItemTemp im ON im.Id = f.IdMainItem
						   INNER JOIN @ItemTemp id ON id.Id = f.IdDetailItem
						   INNER JOIN UnitMeasurement um ON um.Id = id.IdUnitMeasurement
						   INNER JOIN AccountingItem ai ON ai.Id = id.IdAccountingItem
