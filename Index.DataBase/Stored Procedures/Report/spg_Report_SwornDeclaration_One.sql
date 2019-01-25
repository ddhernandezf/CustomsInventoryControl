CREATE PROCEDURE [dbo].[spg_Report_SwornDeclaration_One]
	@IdCustomer	INT,
	@IdAccount	INT,
	@StartDate	DATE,
	@EndDate	DATE,
	@TransFlag	BIT,
	@HeaderList	VARCHAR(MAX),
	@DetailList	VARCHAR(MAX),
	@UseFreezE	BIT
AS
	DECLARE	@HeaderListTable TABLE(
		[IdFileHeaderTemp]	INT
	)

	DECLARE	@DetailListTable TABLE(
		[IdFileDetailTemp]	INT
	)
	
	DECLARE @CustomerTemp TABLE(
		[IdPerson]				INT NOT NULL,
		[CustomerName]			VARCHAR(400) NULL,
		[Nit]					VARCHAR(15) NULL,
		[Address]				VARCHAR(250) NULL,
		[PhoneNumber]			VARCHAR(15) NULL,
		[PersonCode]			NVARCHAR(100) NULL,
		[ImporterCode]			NVARCHAR(100) NULL,
		[ResolutionRate]		NVARCHAR(100) NULL,
		[ResolutionStartDate]	DATE NULL,
		[ResolutionEndDate]		DATE NULL
	)

	DECLARE @FileHeaderTemp TABLE(
		[Id]				INT NOT NULL,
		[IdCustomer]		INT NOT NULL,
		[IdFileInfoConfig]	INT NOT NULL,
		[IdDocument]		VARCHAR(100) NULL,
		[AuthorizationDate] DATETIME NULL,
		[ExpantionDate]		DATETIME NULL,
		[ExpirationDate]	DATETIME NULL,
		[DocumentDate]		DATETIME NULL,
		[ArrivalDate]		DATETIME NULL,
		[ExchangeRate]		DECIMAL(18,6) NULL,
		[Insurance]			DECIMAL(18,6) NULL,
		[Cargo]				DECIMAL(18,6) NULL,
		[IdCustom]			INT NULL,
		[IdCountry]			INT NULL,
		[IdWarranty]		INT NULL,
		[IdCellar]			INT NULL,
		[IdState]			INT NULL,
		[IdCurrency]		INT NULL,
		[IdResolution]		INT NULL,
		[IdAccount]			INT NULL,
		[Reviewed]			BIT NOT NULL DEFAULT 0,
		[CIFTotal]			DECIMAL(18,6) NULL,
		[LinesTotal]		INT NULL,
		[RegisterDate]		DATETIME NOT NULL,
		[RegisterUser]		VARCHAR(60) NOT NULL,
		[CreateDate]		DATETIME NOT NULL,
		[UpdateDate]		DATETIME NULL
	)
	
	DECLARE @FileItemDischargeTemp TABLE (
		[IdItem]				INT NOT NULL,
		[IdFileDetailStock]		INT NOT NULL,
		[Quantity]				DECIMAL(18,6) NOT NULL,
		[Decrease]				DECIMAL(18,6) NOT NULL,
		[CIFcost]				DECIMAL(18,6) NOT NULL,
		[FOcost]				DECIMAL(18,6) NULL,
		[CustomDuties]			DECIMAL(18,6) NULL,
		[Iva]					DECIMAL(18,6) NOT NULL
	)

	DECLARE @FileItemDischargePast TABLE (
		[IdItem]				INT NOT NULL,
		[IdFileDetailStock]		INT NOT NULL,
		[Quantity]				DECIMAL(18,6) NOT NULL,
		[Decrease]				DECIMAL(18,6) NOT NULL,
		[CIFcost]				DECIMAL(18,6) NOT NULL,
		[FOcost]				DECIMAL(18,6) NULL,
		[CustomDuties]			DECIMAL(18,6) NULL,
		[Iva]					DECIMAL(18,6) NOT NULL
	)

	DECLARE @ItemInventoryTemp TABLE (
		[IdCustomer]		INT NOT NULL,
		[IdAccount]			INT NOT NULL,
		[IdFileHeader]		INT NOT NULL,
		[IdFileDetail]		INT NOT NULL,
		[IdItem]			INT NOT NULL,
		[Original]			DECIMAL(18,6) NOT NULL,
		[Stock]				DECIMAL(18,6) NOT NULL,
		[CIFcost]			DECIMAL(18,6) NOT NULL,
		[FOcost]			DECIMAL(18,6) NULL,
		[CustomDuties]		DECIMAL(18,6) NULL,
		[Iva]				DECIMAL(18,6) NOT NULL,
		[TransactionDate]	DATETIME NOT NULL,
		[IdState]			INT NOT NULL,
		[Freeze]			DECIMAL(18,6) NULL
	)

	DECLARE @FileDetailTemp TABLE (
		[Id]				INT NOT NULL,
		[IdFileHeader]		INT NOT NULL,
		[IdState]			INT NOT NULL,
		[TransactionLine]	INT NULL,
		[IdItem]			INT NOT NULL,
		[ItemQuantity]		DECIMAL(18, 6) NULL,
		[CIFCotQuetzal]		DECIMAL(18,6) NULL,
		[FOCostQuetzal]		DECIMAL(18,6) NULL,
		[CIFCotDollar]		DECIMAL(18,6) NULL,
		[FOCostDollar]		DECIMAL(18,6) NULL,
		[CustomDuties]		DECIMAL(18,6) NULL,
		[Iva]				DECIMAL(18,6) NULL,
		[TaxableBase]		DECIMAL(18,6) NULL,
		[TaxRate]			DECIMAL(18,6) NULL,
		[NetWeight]			DECIMAL(18,6) NULL,
		[GrossWeight]		DECIMAL(18,6) NULL,
		[RegisterDate]		DATETIME NULL,
		[RegisterUser]		VARCHAR(60) NOT NULL,
		[IsFrozen]			BIT
	)

	DECLARE @FileAttachedTemp TABLE (
		[Id]				INT,
		[AttachedNumber]	VARCHAR(100) NULL,
		[CustomerName]		VARCHAR(400) NULL,
		[Nit]				VARCHAR(15) NULL,
		[Address]			VARCHAR(250) NULL,
		[PhoneNumber]		VARCHAR(15) NULL	
	)

	IF(ISNULL(@HeaderList, '') <> '')
		BEGIN
			INSERT INTO @HeaderListTable(IdFileHeaderTemp)
			SELECT Item = CONVERT(INT, Item) 
			  FROM	(	SELECT	Item = x.i.value('(./text())[1]', 'varchar(max)')
						  FROM	(	SELECT [XML] = CONVERT(XML, '<i>'
												+ REPLACE(@HeaderList, ',', '</i><i>') + '</i>').query('.')
					  ) AS a CROSS APPLY [XML].nodes('i') AS x(i) 
					  ) AS y
			 WHERE Item IS NOT NULL
		END

	IF(ISNULL(@DetailList, '') <> '')
		BEGIN
			INSERT INTO @DetailListTable(IdFileDetailTemp)
			SELECT Item = CONVERT(INT, Item) 
			  FROM	(	SELECT	Item = x.i.value('(./text())[1]', 'varchar(max)')
						  FROM	(	SELECT [XML] = CONVERT(XML, '<i>'
												+ REPLACE(@DetailList, ',', '</i><i>') + '</i>').query('.')
					  ) AS a CROSS APPLY [XML].nodes('i') AS x(i) 
					  ) AS y
			 WHERE Item IS NOT NULL
		END

	INSERT INTO @CustomerTemp(IdPerson, CustomerName, Nit, PersonCode, [Address], PhoneNumber, ImporterCode, ResolutionRate,
								ResolutionStartDate, ResolutionEndDate)
	SELECT	c.IdPerson, 
		CASE WHEN p.IsEnterprise = 1
			THEN p.EnterpriseName
			ELSE
				CASE WHEN p.LastName IS NULL	
					THEN p.FirstName
					ELSE CONCAT(p.FirstName, ' ', p.LastName)
				END
		END[CustomerName],
		p.Nit, c.PersonCode, 
		(	SELECT	TOP 1 a.[Address]
			  FROM	[Address] a INNER JOIN [AddressType] att ON a.IdAddressType = att.Id
			 WHERE	a.IdPerson = c.IdPerson
			   AND	att.[Description] in ('Negocio', 'Trabajo', 'Oficina'))[Address],
		(	SELECT	TOP 1 pp.Number
			  FROM	[Phone] pp INNER JOIN [PhoneType] pt ON pp.IdPhoneType = pt.Id
			 WHERE	pp.IdPerson = c.IdPerson
			   AND	pt.[Description] in ('Trabajo', 'Oficina'))[PhoneNumber],
		c.ImporterCode, ca.ResolutionRate, ca.ResolutionStartDate, ca.ResolutionEndDate
	  FROM	Customer c INNER JOIN Person p ON p.Id = c.IdPerson
					   INNER JOIN CustomerAccount ca ON ca.IdCustomer = c.IdPerson
													 AND ca.IdAccount = @IdAccount
	 WHERE	c.IdPerson = @IdCustomer

	IF(@TransFlag IS NULL)
		BEGIN
			INSERT INTO @FileItemDischargeTemp(IdItem, IdFileDetailStock, Quantity, Decrease, CIFcost, FOcost, CustomDuties, Iva)
			SELECT	fd.IdItem, fid.IdFileDetailStock, SUM(fid.Quantity),  SUM(fid.Decrease),  SUM(fid.CIFcost),  SUM(fid.FOcost),  
							SUM(fid.CustomDuties),  SUM(fid.Iva)
			  FROM	[FileItemDischarge] fid INNER JOIN FileDetail fd ON fd.Id = fid.IdFileDetailStock
											INNER JOIN FileHeader fh ON fh.Id = fd.IdFileHeader
			 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate AND @EndDate
			   AND	fh.IdCustomer = @IdCustomer
			   AND	fh.IdAccount = @IdAccount
			 GROUP BY fd.IdItem, fid.IdFileDetailStock
		END
	ELSE
		BEGIN
			DECLARE	@IdStateTransmited	INT;
			SELECT @IdStateTransmited = Id FROM [State] WHERE [Name] = 'Transmitido';

			IF(@TransFlag = 1)
				BEGIN
					INSERT INTO @FileItemDischargeTemp(IdItem, IdFileDetailStock, Quantity, Decrease, CIFcost, FOcost, CustomDuties, Iva)
					SELECT	fd.IdItem, fid.IdFileDetailStock, SUM(fid.Quantity),  SUM(fid.Decrease),  SUM(fid.CIFcost),  SUM(fid.FOcost),  
									SUM(fid.CustomDuties),  SUM(fid.Iva)
					  FROM	[FileItemDischarge] fid INNER JOIN FileDetail fd ON fd.Id = fid.IdFileDetailStock
													INNER JOIN FileHeader fh ON fh.Id = fd.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate AND @EndDate
					   AND	fh.IdCustomer = @IdCustomer
					   AND	fh.IdAccount = @IdAccount
					   AND	fid.IdState = @IdStateTransmited
					 GROUP BY fd.IdItem, fid.IdFileDetailStock
				END
			ELSE IF(@TransFlag = 0)
				BEGIN
					INSERT INTO @FileItemDischargeTemp(IdItem, IdFileDetailStock, Quantity, Decrease, CIFcost, FOcost, CustomDuties, Iva)
					SELECT	fd.IdItem, fid.IdFileDetailStock, SUM(fid.Quantity),  SUM(fid.Decrease),  SUM(fid.CIFcost),  SUM(fid.FOcost),  
									SUM(fid.CustomDuties),  SUM(fid.Iva)
					  FROM	[FileItemDischarge] fid INNER JOIN FileDetail fd ON fd.Id = fid.IdFileDetailStock
													INNER JOIN FileHeader fh ON fh.Id = fd.IdFileHeader
					 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN @StartDate AND @EndDate
					   AND	fh.IdCustomer = @IdCustomer
					   AND	fh.IdAccount = @IdAccount
					   AND	fid.IdState <> @IdStateTransmited
					 GROUP BY fd.IdItem, fid.IdFileDetailStock
				END
		END

	INSERT INTO @FileItemDischargePast(IdItem, IdFileDetailStock, Quantity, Decrease, CIFcost, FOcost, CustomDuties, Iva)
	SELECT	fd.IdItem, fid.IdFileDetailStock, SUM(fid.Quantity),  SUM(fid.Decrease),  SUM(fid.CIFcost),  SUM(fid.FOcost),  
			SUM(fid.CustomDuties),  SUM(fid.Iva)
	  FROM	[FileItemDischarge] fid INNER JOIN FileDetail fd ON fd.Id = fid.IdFileDetailStock
									INNER JOIN FileHeader fh ON fh.Id = fd.IdFileHeader
	 WHERE	CONVERT(DATE, fid.RegisterDate) BETWEEN fh.AuthorizationDate AND DATEADD(dd, -1, @StartDate)
	   AND	fh.IdCustomer = @IdCustomer
	   AND	fh.IdAccount = @IdAccount
	 GROUP	BY fd.IdItem, fid.IdFileDetailStock

	DECLARE	@DetailListCounter	INT = (SELECT COUNT(*) FROM @DetailListTable);

	IF(@DetailListCounter > 0)
		BEGIN
			INSERT INTO @ItemInventoryTemp(IdCustomer, IdAccount, IdFileHeader, IdFileDetail, IdItem, Original, Stock,
											CIFcost, FOcost, CustomDuties, Iva, TransactionDate, IdState, Freeze)
			SELECT	ii.IdCustomer, ii.IdAccount, ii.IdFileHeader, ii.IdFileDetail, ii.IdItem, ii.Quantity, ii.Stock,
					ii.CIFcost, ii.FOcost, ii.CustomDuties, ii.Iva, ii.TransactionDate, ii.IdState, ii.Freeze
			  FROM	ItemInventory ii LEFT OUTER JOIN @FileItemDischargeTemp fid ON ii.IdFileDetail = fid.IdFileDetailStock
									 INNER JOIN FileHeader fh ON fh.Id = ii.IdFileHeader
									 INNER JOIN @DetailListTable dlt ON dlt.IdFileDetailTemp = ii.IdFileDetail
			 WHERE	ii.IdCustomer = @IdCustomer
			   AND	ii.IdAccount = @IdAccount
			   AND	CONVERT(DATE, fh.AuthorizationDate) <= @EndDate
		END
	ELSE
		BEGIN
			INSERT INTO @ItemInventoryTemp(IdCustomer, IdAccount, IdFileHeader, IdFileDetail, IdItem, Original, Stock,
											CIFcost, FOcost, CustomDuties, Iva, TransactionDate, IdState, Freeze)
			SELECT	ii.IdCustomer, ii.IdAccount, ii.IdFileHeader, ii.IdFileDetail, ii.IdItem, ii.Quantity, ii.Stock,
					ii.CIFcost, ii.FOcost, ii.CustomDuties, ii.Iva, ii.TransactionDate, ii.IdState, ii.Freeze
			  FROM	ItemInventory ii LEFT OUTER JOIN @FileItemDischargeTemp fid ON ii.IdFileDetail = fid.IdFileDetailStock
									 INNER JOIN FileHeader fh ON fh.Id = ii.IdFileHeader
			 WHERE	ii.IdCustomer = @IdCustomer
			   AND	ii.IdAccount = @IdAccount
			   AND	CONVERT(DATE, fh.AuthorizationDate) <= @EndDate
		END

	INSERT INTO @FileDetailTemp(Id, IdFileHeader, IdState, TransactionLine, IdItem, ItemQuantity, CIFCotQuetzal, FOCostQuetzal, CIFCotDollar,
								FOCostDollar, CustomDuties, Iva, TaxableBase, TaxRate, NetWeight, GrossWeight, RegisterDate, RegisterUser,
								IsFrozen)
	SELECT	fd.Id, fd.IdFileHeader, fd.IdState, fd.TransactionLine, fd.IdItem, fd.ItemQuantity, fd.CIFCotQuetzal, fd.FOCostQuetzal, fd.CIFCotDollar,
			fd.FOCostDollar, fd.CustomDuties, fd.Iva, fd.TaxableBase, fd.TaxRate, fd.NetWeight, fd.GrossWeight, fd.RegisterDate, fd.RegisterUser,
			CASE WHEN ii.Freeze IS NULL 
				THEN	CONVERT(BIT, 0)
				ELSE	CONVERT(BIT, 1) 
			END [IsFrozen]
	  FROM	FileDetail fd INNER JOIN @ItemInventoryTemp ii ON fd.Id = ii.IdFileDetail

	INSERT INTO @FileHeaderTemp
	SELECT	*
	  FROM	[FileHeader]
	 WHERE	Id IN (	SELECT	DISTINCT IdFileHeader	
					  FROM	@FileDetailTemp)

	INSERT INTO @FileAttachedTemp(Id, AttachedNumber, CustomerName, Nit, [Address], PhoneNumber)
	SELECT	FA.Id, fa.AttachedNumber,
			CASE WHEN p.IsEnterprise = 1
				THEN p.EnterpriseName
				ELSE
					CASE WHEN p.LastName IS NULL	
						THEN p.FirstName
						ELSE CONCAT(p.FirstName, ' ', p.LastName)
					END
			END[SupplierName], p.Nit,
			(	SELECT	TOP 1 a.[Address]
				  FROM	[Address] a INNER JOIN [AddressType] att ON a.IdAddressType = att.Id
				 WHERE	a.IdPerson = s.IdPerson
				   AND	att.[Description] in ('Negocio', 'Trabajo', 'Oficina'))[Address],
			(	SELECT	TOP 1 pp.Number
				  FROM	[Phone] pp INNER JOIN [PhoneType] pt ON pp.IdPhoneType = pt.Id
				 WHERE	pp.IdPerson = s.IdPerson
				   AND	pt.[Description] in ('Trabajo', 'Oficina'))[PhoneNumber]
	  FROM	FileAttached fa INNER JOIN @FileHeaderTemp fh ON fh.Id = fa.IdFileHeader
							INNER JOIN Supplier s ON s.IdPerson = fa.IdSupplier
							INNER JOIN Person p ON p.Id = s.IdPerson

	DECLARE	@HeaderListCounter	INT = (SELECT COUNT(*) FROM @HeaderListTable)

	IF(@HeaderListCounter > 0)
		BEGIN
			SELECT	fh.Id[Id_Cabecera_Importacion], fh.IdDocument[Poliza_Importacion], fh.AuthorizationDate[Fecha_Autorizacion], 
					fh.ExpirationDate[Fecha_Vencimiento], fh.ExchangeRate[Tipo_Cambio], c.Code[Id_Aduana], fh.RegisterDate[Fecha_Sistema],
					fh.Insurance[Seguro], fh.Cargo[Flete],
					(	SELECT	TOP 1 AttachedNumber
						  FROM	@FileAttachedTemp
						 WHERE	IdFileHeader = fh.Id
						 ORDER BY Id ASC)[Numero_Factura],
					CASE WHEN fh.IdResolution IS NULL THEN 0 ELSE fh.IdResolution END [Numero_Resolucion],
					CASE WHEN	@IdAccount = 2 
						THEN NULL
						ELSE w.[Name]
					END[Des_Garantia],
					c.[Name][Des_Aduana], ct.[Name][Des_Pais],fd.Id[Id_Detalle_Importacion], fd.TransactionLine[Linea_Importacion], fd.ItemQuantity[Cantidad], 
					ISNULL(fd.CIFCotQuetzal, 0)[Costo_Cif_Quetzales], ISNULL(fd.FOCostQuetzal, 0)[Costo_Fob_Quetzales], ISNULL(fd.CustomDuties, 0)[Derechos_Suspenso], 
					ISNULL(fd.Iva, 0)[Iva_Suspenso],
					ctt.IdPerson[Id_Cliente], ctt.CustomerName[Nombre_Cliente], ctt.Nit[Nit_Cliente], ctt.[Address][Direccion_Cliente], 
					ctt.PhoneNumber[Telefono_Cliente], ctt.PersonCode[Codigo_Cliente], ctt.ImporterCode[Codigo_Importador_Exportador], 
					ctt.ResolutionRate[Resolucion_Calificacion], ctt.ResolutionStartDate[Fecha_Resolucion], 
					ctt.ResolutionEndDate[C_Vencimiento],
					(	SELECT	TOP 1 fat.CustomerName
						  FROM	@FileAttachedTemp fat
						 WHERE	IdFileHeader = fh.Id
						 ORDER BY Id ASC)[Nombre_Proveedor],
					(	SELECT	TOP 1 fat.Nit
						  FROM	@FileAttachedTemp fat
						 WHERE	IdFileHeader = fh.Id
						 ORDER BY Id ASC)[Nit_Proveedor],
					(	SELECT	TOP 1 fat.[Address]
						  FROM	@FileAttachedTemp fat
						 WHERE	IdFileHeader = fh.Id
						 ORDER BY Id ASC)[Direccion_Proveedor],
					(	SELECT	TOP 1 fat.PhoneNumber
						  FROM	@FileAttachedTemp fat
						 WHERE	IdFileHeader = fh.Id
						 ORDER BY Id ASC)[Telefono_Proveedor],
					i.[Name][Des_Materia_Prima], i.Code[Codigo_Materia_Prima], a.AccountingItem[Partida_Materia], u.[Name][Des_Unidad_Medida], 
					r.[Name][Des_Resolucion],
					ISNULL(fid.CustomDuties, 0)[Suspenso_Formula], ISNULL(fid.Iva, 0)[IVA_Formula], 
					(ISNULL(fid.Quantity, 0) + ISNULL(fid.Decrease, 0))[Cantidad_Formula], 
					ISNULL(fid.CIFcost, 0)[Costo_Cif_Formula],
					ISNULL(fidp.CustomDuties, 0)[V_Suspenso_Formula], ISNULL(fidp.Iva, 0)[V_IVA_Formula], 
					(ISNULL(fidp.Quantity, 0) + ISNULL(fidp.Decrease, 0))[V_Cantidad_Formula], 
					ISNULL(fidp.CIFcost, 0)[V_Costo_Cif_Formula], fd.IsFrozen
			  FROM	@FileHeaderTemp fh LEFT JOIN Warranty w ON w.Id = fh.IdWarranty
									   LEFT JOIN Customs c ON c.Id = fh.IdCustom
									   LEFT JOIN Country ct ON ct.Id = fh.IdCountry
									   INNER JOIN @FileDetailTemp fd ON fd.IdFileHeader = fh.Id
									   INNER JOIN @CustomerTemp ctt ON ctt.IdPerson = fh.IdCustomer
									   INNER JOIN Item i ON i.Id = fd.IdItem
									   INNER JOIN UnitMeasurement u ON u.Id = i.IdUnitMeasurement
									   INNER JOIN AccountingItem a ON a.Id = i.IdAccountingItem
									   INNER JOIN Resolution r ON r.Id = i.IdResolution
									   LEFT OUTER JOIN @FileItemDischargeTemp fid ON fid.IdFileDetailStock = fd.Id
																					AND fid.IdItem = fd.IdItem
									   LEFT OUTER JOIN @FileItemDischargePast fidp ON fidp.IdFileDetailStock = fd.Id
																					AND fidP.IdItem = fd.IdItem
									   INNER JOIN @HeaderListTable hlt on hlt.IdFileHeaderTemp = fh.Id
				WHERE round(fd.ItemQuantity ,2) > round(IsNull(fidp.Quantity,0)+IsNull(fidp.Decrease,0),2)
		END
	ELSE
		BEGIN
			SELECT	fh.Id[Id_Cabecera_Importacion], fh.IdDocument[Poliza_Importacion], fh.AuthorizationDate[Fecha_Autorizacion], 
					fh.ExpirationDate[Fecha_Vencimiento], fh.ExchangeRate[Tipo_Cambio], c.Code[Id_Aduana], fh.RegisterDate[Fecha_Sistema],
					fh.Insurance[Seguro], fh.Cargo[Flete],
					(	SELECT	TOP 1 AttachedNumber
						  FROM	@FileAttachedTemp
						 WHERE	IdFileHeader = fh.Id
						 ORDER BY Id ASC)[Numero_Factura],
					CASE WHEN fh.IdResolution IS NULL THEN 0 ELSE fh.IdResolution END [Numero_Resolucion],
					CASE WHEN	@IdAccount = 2 
						THEN NULL
						ELSE w.[Name]
					END[Des_Garantia],
					c.[Name][Des_Aduana], ct.[Name][Des_Pais], fd.Id[Id_Detalle_Importacion], fd.TransactionLine[Linea_Importacion], fd.ItemQuantity[Cantidad], 
					ISNULL(fd.CIFCotQuetzal, 0)[Costo_Cif_Quetzales], ISNULL(fd.FOCostQuetzal, 0)[Costo_Fob_Quetzales], ISNULL(fd.CustomDuties, 0)[Derechos_Suspenso], 
					ISNULL(fd.Iva, 0)[Iva_Suspenso],
					ctt.IdPerson[Id_Cliente], ctt.CustomerName[Nombre_Cliente], ctt.Nit[Nit_Cliente], ctt.[Address][Direccion_Cliente], 
					ctt.PhoneNumber[Telefono_Cliente], ctt.PersonCode[Codigo_Cliente], ctt.ImporterCode[Codigo_Importador_Exportador], 
					ctt.ResolutionRate[Resolucion_Calificacion], ctt.ResolutionStartDate[Fecha_Resolucion], 
					ctt.ResolutionEndDate[C_Vencimiento],
					(	SELECT	TOP 1 fat.CustomerName
						  FROM	@FileAttachedTemp fat
						 WHERE	IdFileHeader = fh.Id
						 ORDER BY Id ASC)[Nombre_Proveedor],
					(	SELECT	TOP 1 fat.Nit
						  FROM	@FileAttachedTemp fat
						 WHERE	IdFileHeader = fh.Id
						 ORDER BY Id ASC)[Nit_Proveedor],
					(	SELECT	TOP 1 fat.[Address]
						  FROM	@FileAttachedTemp fat
						 WHERE	IdFileHeader = fh.Id
						 ORDER BY Id ASC)[Direccion_Proveedor],
					(	SELECT	TOP 1 fat.PhoneNumber
						  FROM	@FileAttachedTemp fat
						 WHERE	IdFileHeader = fh.Id
						 ORDER BY Id ASC)[Telefono_Proveedor],
					i.[Name][Des_Materia_Prima], i.Code[Codigo_Materia_Prima], a.AccountingItem[Partida_Materia], u.[Name][Des_Unidad_Medida], 
					r.[Name][Des_Resolucion],
					ISNULL(fid.CustomDuties, 0)[Suspenso_Formula], ISNULL(fid.Iva, 0)[IVA_Formula], 
					(ISNULL(fid.Quantity, 0) + ISNULL(fid.Decrease, 0))[Cantidad_Formula], 
					ISNULL(fid.CIFcost, 0)[Costo_Cif_Formula],
					ISNULL(fidp.CustomDuties, 0)[V_Suspenso_Formula], ISNULL(fidp.Iva, 0)[V_IVA_Formula], 
					(ISNULL(fidp.Quantity, 0) + ISNULL(fidp.Decrease, 0))[V_Cantidad_Formula], 
					ISNULL(fidp.CIFcost, 0)[V_Costo_Cif_Formula], fd.IsFrozen
			  FROM	@FileHeaderTemp fh LEFT JOIN Warranty w ON w.Id = fh.IdWarranty
									   LEFT JOIN Customs c ON c.Id = fh.IdCustom
									   LEFT JOIN Country ct ON ct.Id = fh.IdCountry
									   INNER JOIN @FileDetailTemp fd ON fd.IdFileHeader = fh.Id
									   INNER JOIN @CustomerTemp ctt ON ctt.IdPerson = fh.IdCustomer
									   INNER JOIN Item i ON i.Id = fd.IdItem
									   INNER JOIN UnitMeasurement u ON u.Id = i.IdUnitMeasurement
									   INNER JOIN AccountingItem a ON a.Id = i.IdAccountingItem
									   INNER JOIN Resolution r ON r.Id = i.IdResolution
									   LEFT OUTER JOIN @FileItemDischargeTemp fid ON fid.IdFileDetailStock = fd.Id
																					AND fid.IdItem = fd.IdItem
									   LEFT OUTER JOIN @FileItemDischargePast fidp ON fidp.IdFileDetailStock = fd.Id
																					AND fidP.IdItem = fd.IdItem
				WHERE round(fd.ItemQuantity ,2) > round(IsNull(fidp.Quantity,0)+IsNull(fidp.Decrease,0),2)
		END