CREATE PROCEDURE [dbo].[spg_DischargeRawMaterial]
	@IdFileDetail	INT,
	@IdAccount		INT,
	@IdCustomer		INT,
	@IdItem			INT,
	@UseFormula		BIT
AS 
	DECLARE @TempItem TABLE (
		[Id] INT NOT NULL,
		[IdAccount] INT NULL,
		[IdCustomer] INT NOT NULL,
		[IdAccountingItem] INT NOT NULL,
		[IdUnitMeasurement] INT NOT NULL,
		[Code] NVARCHAR(50) NOT NULL,
		[Name] VARCHAR(200) NOT NULL,
		[Description] VARCHAR(1000) NULL,
		[Barcode] NVARCHAR(100) NULL,
		[IsProduct] BIT NOT NULL
	)

	DECLARE @TempCurrent TABLE(
		[Id] INT NOT NULL,
		[IdFileDetailSubstract] INT NOT NULL,
		[IdFileDetailStock] INT NOT NULL,
		[IdState] INT NOT NULL,
		[Quantity] DECIMAL(18,6) NOT NULL,
		[Decrease] DECIMAL(18,6) NOT NULL,
		[IdItem] INT NOT NULL
	)

	DECLARE	@ThresholdDate DATE = '2016-03-31',
			@SubstractDate	DATE,
			@UseExpired		BIT

	SELECT	@UseExpired = fc.UseExpired, @SubstractDate = fh.AuthorizationDate
	  FROM	[FileDetail] fd INNER JOIN [FileHeader] fh ON fh.Id = fd.IdFileHeader
							INNER JOIN [FileInfoConfig] fc ON fc.Id = fh.IdFileInfoConfig
	 WHERE	fd.Id = @IdFileDetail

	INSERT INTO @TempCurrent(Id, IdFileDetailSubstract, IdFileDetailStock, IdState, Quantity,
							Decrease, IdItem)
	SELECT	fid.Id, fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity,
			fid.Decrease, fd.IdItem
	  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fd ON fid.IdFileDetailStock = fd.Id
	 WHERE	IdFileDetailSubstract = @IdFileDetail
	
	IF(@UseFormula = 1)
		BEGIN
			DECLARE @Quantity	DECIMAL(18,6)

			SELECT @Quantity = ItemQuantity FROM FileDetail WHERE Id = @IdFileDetail;
			
			IF (@UseExpired = 1)
				BEGIN
					SELECT	@IdFileDetail[IdFileDetail], f.Id[IdFormula], f.IdMainItem[IdParentItem], f.IdDetailItem[IdItem], ai.AccountingItem,
							CONCAT(i.[Name], ' (', um.Symbol, ')')[ItemName], 
							(@Quantity * f.Quantity)[Quantity], (@Quantity * f.Decrease)[Decrease], @UseFormula[UseFormula],
							(SELECT CONVERT(DECIMAL(18,6), ISNULL(SUM(Quantity), 0)) FROM @TempCurrent WHERE IdItem= i.Id)[CurrentQuantity],
							(SELECT CONVERT(DECIMAL(18,6), ISNULL(SUM(Decrease), 0)) FROM @TempCurrent WHERE IdItem= i.Id)[CurrentDecrease],
							CONCAT(i.Code, ' - ', i.Name, ' (', um.Symbol, ')')[DisplayItemName],
							CONCAT(ai.AccountingItem, ' - ', ai.Description)[DisplayAccountingItem]
					  FROM	[Formula] f INNER JOIN [Item] i ON f.IdDetailItem = i.Id
										INNER JOIN [UnitMeasurement] um ON um.Id = i.IdUnitMeasurement
										INNER JOIN [AccountingItem] ai ON ai.Id = i.IdAccountingItem
										INNER JOIN (	SELECT	DISTINCT i.Id
														  FROM	ItemInventory ii INNER JOIN Item i ON ii.IdItem = i.Id
																				 INNER JOIN FileHeader fh ON ii.IdFileHeader = fh.Id
														 WHERE	ii.IdItem IN (	SELECT	DISTINCT f.IdDetailItem
																				  FROM	Formula f INNER JOIN Item i ON i.Id = f.IdMainItem
																				 WHERE  i.IdAccount = @IdAccount
																				   AND	i.IdCustomer =  @IdCustomer
																				   AND	f.IdMainItem = @IdItem)
														   AND	fh.AuthorizationDate <= @SubstractDate
														   AND	ii.Stock > 0
														UNION
														SELECT	DISTINCT i.Id
														  FROM	ItemInventory ii INNER JOIN Item i ON ii.IdItem = i.Id
																				 INNER JOIN FileHeader fh ON ii.IdFileHeader = fh.Id
																				 INNER JOIN FileItemDischarge fid ON fid.IdFileDetailStock = ii.IdFileDetail
														 WHERE	ii.IdItem IN (	SELECT	DISTINCT f.IdDetailItem
																				  FROM	Formula f INNER JOIN Item i ON i.Id = f.IdMainItem
																				 WHERE  i.IdAccount = @IdAccount
																				   AND	i.IdCustomer =  @IdCustomer
																				   AND	f.IdMainItem = @IdItem)
														   AND	fh.AuthorizationDate <= @SubstractDate
														   AND	fid.IdFileDetailSubstract = @IdFileDetail) t ON t.Id = f.IdDetailItem
					 WHERE	f.IdMainItem = @IdItem
					   AND	I.IdAccount = @IdAccount
					   AND	f.Active = 1
					 ORDER	BY i.Code ASC
					 
				END
			ELSE
				BEGIN
					SELECT	@IdFileDetail[IdFileDetail], f.Id[IdFormula], f.IdMainItem[IdParentItem], f.IdDetailItem[IdItem], ai.AccountingItem,
							CONCAT(i.[Name], ' (', um.Symbol, ')')[ItemName], 
							(@Quantity * f.Quantity)[Quantity], (@Quantity * f.Decrease)[Decrease], @UseFormula[UseFormula],
							(SELECT CONVERT(DECIMAL(18,6), ISNULL(SUM(Quantity), 0)) FROM @TempCurrent WHERE IdItem= i.Id)[CurrentQuantity],
							(SELECT CONVERT(DECIMAL(18,6), ISNULL(SUM(Decrease), 0)) FROM @TempCurrent WHERE IdItem= i.Id)[CurrentDecrease],
							CONCAT(i.Code, ' - ', i.Name, ' (', um.Symbol, ')')[DisplayItemName],
							CONCAT(ai.AccountingItem, ' - ', ai.Description)[DisplayAccountingItem]
					  FROM	[Formula] f INNER JOIN [Item] i ON f.IdDetailItem = i.Id
										INNER JOIN [UnitMeasurement] um ON um.Id = i.IdUnitMeasurement
										INNER JOIN [AccountingItem] ai ON ai.Id = i.IdAccountingItem
										INNER JOIN (	SELECT	DISTINCT i.Id
														  FROM	ItemInventory ii INNER JOIN Item i ON ii.IdItem = i.Id
																				 INNER JOIN FileHeader fh ON ii.IdFileHeader = fh.Id
														 WHERE	ii.IdItem IN (	SELECT	DISTINCT f.IdDetailItem
																				  FROM	Formula f INNER JOIN Item i ON i.Id = f.IdMainItem
																				 WHERE  i.IdAccount = @IdAccount
																				   AND	i.IdCustomer =  @IdCustomer
																				   AND	f.IdMainItem = @IdItem)
														   AND	fh.AuthorizationDate <= @SubstractDate
														   AND (CASE WHEN (CONVERT(DATE, fh.AuthorizationDate) < @ThresholdDate)  -- Valicacion agregada, quemada para polizas que no tienen ampliacion y las que si
																	THEN CONVERT(DATE, dateadd(mm, 12, fh.ExpirationDate))
																	ELSE CONVERT(DATE, fh.ExpirationDate) END) > CONVERT(DATE, GETDATE())

														   AND	ii.Stock > 0
														UNION
														SELECT	DISTINCT i.Id
														  FROM	ItemInventory ii INNER JOIN Item i ON ii.IdItem = i.Id
																				 INNER JOIN FileHeader fh ON ii.IdFileHeader = fh.Id
																				 INNER JOIN FileItemDischarge fid ON fid.IdFileDetailStock = ii.IdFileDetail
														 WHERE	ii.IdItem IN (	SELECT	DISTINCT f.IdDetailItem
																				  FROM	Formula f INNER JOIN Item i ON i.Id = f.IdMainItem
																				 WHERE  i.IdAccount = @IdAccount
																				   AND	i.IdCustomer =  @IdCustomer
																				   AND	f.IdMainItem = @IdItem)
														   AND	fh.AuthorizationDate <= @SubstractDate
														   AND	fid.IdFileDetailSubstract = @IdFileDetail
														   AND (CASE WHEN (CONVERT(DATE, fh.AuthorizationDate) < @ThresholdDate)  -- Valicacion agregada, quemada para polizas que no tienen ampliacion y las que si
																	THEN CONVERT(DATE, dateadd(mm, 12, fh.ExpirationDate))
																	ELSE CONVERT(DATE, fh.ExpirationDate) END) > CONVERT(DATE, GETDATE())) t ON t.Id = f.IdDetailItem
					 WHERE	f.IdMainItem = @IdItem
					   AND	I.IdAccount = @IdAccount
					   AND	f.Active = 1
					 ORDER	BY i.Code ASC
				END
		END
	ELSE
		BEGIN
			IF (@UseExpired = 1)
				BEGIN
					INSERT INTO @TempItem(Id, IdAccount, IdCustomer, IdAccountingItem, IdUnitMeasurement, Code, [Name], [Description], 
									Barcode, IsProduct)
					SELECT	Id, IdAccount, IdCustomer, IdAccountingItem, IdUnitMeasurement, Code, [Name], [Description], 
							Barcode, IsProduct
					  FROM	[Item]
					 WHERE	IdCustomer = @IdCustomer
					   AND	IsProduct = 0
					   AND	IdAccount = @IdAccount
					   AND	Active = 1
					   AND	Id in (	SELECT	DISTINCT i.Id
									  FROM	ItemInventory ii INNER JOIN Item i ON ii.IdItem = i.Id
															 INNER JOIN FileHeader fh ON ii.IdFileHeader = fh.Id
									 WHERE	ii.IdItem IN (	SELECT	Id
															  FROM	Item 
															 WHERE	IdAccount = @IdAccount
															   AND	IdCustomer =  @IdCustomer
															   AND	IsProduct = 0)
									   AND	fh.AuthorizationDate <= @SubstractDate
									   AND	ii.Stock > 0
									UNION
									SELECT	DISTINCT i.Id
									  FROM	ItemInventory ii INNER JOIN Item i ON ii.IdItem = i.Id
															 INNER JOIN FileHeader fh ON ii.IdFileHeader = fh.Id
															 INNER JOIN FileItemDischarge fid ON fid.IdFileDetailStock = ii.IdFileDetail
									 WHERE	ii.IdItem IN (	SELECT	Id
															  FROM	Item 
															 WHERE	IdAccount = @IdAccount
															   AND	IdCustomer =  @IdCustomer
															   AND	IsProduct = 0)
									   AND	fid.IdFileDetailSubstract = @IdFileDetail
									   AND	fh.AuthorizationDate <= @SubstractDate)
				END
			ELSE
				BEGIN
					INSERT INTO @TempItem(Id, IdAccount, IdCustomer, IdAccountingItem, IdUnitMeasurement, Code, [Name], [Description], 
									Barcode, IsProduct)
					SELECT	Id, IdAccount, IdCustomer, IdAccountingItem, IdUnitMeasurement, Code, [Name], [Description], 
							Barcode, IsProduct
					  FROM	[Item]
					 WHERE	IdCustomer = @IdCustomer
					   AND	IsProduct = 0
					   AND	IdAccount = @IdAccount
					   AND	Active = 1
					   AND	Id in (	SELECT	DISTINCT i.Id
									  FROM	ItemInventory ii INNER JOIN Item i ON ii.IdItem = i.Id
															 INNER JOIN FileHeader fh ON ii.IdFileHeader = fh.Id
									 WHERE	ii.IdItem IN (	SELECT	Id
															  FROM	Item 
															 WHERE	IdAccount = @IdAccount
															   AND	IdCustomer =  @IdCustomer
															   AND	IsProduct = 0)
									    AND	fh.AuthorizationDate <= @SubstractDate
										AND (CASE WHEN (CONVERT(DATE, fh.AuthorizationDate) < @ThresholdDate)  -- Valicacion agregada, quemada para polizas que no tienen ampliacion y las que si
												THEN CONVERT(DATE, dateadd(mm, 12, fh.ExpirationDate))
												ELSE CONVERT(DATE, fh.ExpirationDate) END) > CONVERT(DATE, GETDATE())
									   AND	ii.Stock > 0
									UNION
									SELECT	DISTINCT i.Id
									  FROM	ItemInventory ii INNER JOIN Item i ON ii.IdItem = i.Id
															 INNER JOIN FileHeader fh ON ii.IdFileHeader = fh.Id
															 INNER JOIN FileItemDischarge fid ON fid.IdFileDetailStock = ii.IdFileDetail
									 WHERE	ii.IdItem IN (	SELECT	Id
															  FROM	Item 
															 WHERE	IdAccount = @IdAccount
															   AND	IdCustomer =  @IdCustomer
															   AND	IsProduct = 0)
									    AND	fh.AuthorizationDate <= @SubstractDate
										AND (CASE WHEN (CONVERT(DATE, fh.AuthorizationDate) < @ThresholdDate)  -- Valicacion agregada, quemada para polizas que no tienen ampliacion y las que si
												THEN CONVERT(DATE, dateadd(mm, 12, fh.ExpirationDate))
												ELSE CONVERT(DATE, fh.ExpirationDate) END) > CONVERT(DATE, GETDATE())
									   AND	fid.IdFileDetailSubstract = @IdFileDetail)
				END

			SELECT	@IdFileDetail[IdFileDetail], 0[IdFormula], @IdItem[IdParentItem], i.Id[IdItem], ai.AccountingItem,
					CONCAT(i.[Name], ' (', um.Symbol, ')')[ItemName], 
					CONVERT(DECIMAL(18,6), 0)[Quantity], CONVERT(DECIMAL(18,6), 0)[Decrease], @UseFormula[UseFormula],
					(SELECT CONVERT(DECIMAL(18,6), ISNULL(SUM(Quantity), 0)) FROM @TempCurrent WHERE IdItem= i.Id)[CurrentQuantity],
					(SELECT CONVERT(DECIMAL(18,6), ISNULL(SUM(Decrease), 0)) FROM @TempCurrent WHERE IdItem= i.Id)[CurrentDecrease],
					CONCAT(i.Code, ' - ', i.Name, ' (', um.Symbol, ')')[DisplayItemName],
					CONCAT(ai.AccountingItem, ' - ', ai.Description)[DisplayAccountingItem]
			  FROM	@TempItem i INNER JOIN [UnitMeasurement] um ON um.Id = i.IdUnitMeasurement
								INNER JOIN [AccountingItem] ai ON ai.Id = i.IdAccountingItem
			 WHERE	i.IdAccount = @IdAccount
			 ORDER	BY i.Code ASC
		END
GO


