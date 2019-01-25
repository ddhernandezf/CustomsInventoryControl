----------------------------------------------------------INGRESO DE CUENTAS PARA EL EJERCICIO----------------------------------------------------------
--INSERT INTO [Account] VALUES ('Importación estandar', 'Importación estandar', GETDATE(), 'QA_USER')
--INSERT INTO [Account] VALUES ('Importación extraordinaria', 'Importación extraordinaria', GETDATE(), 'QA_USER')
--INSERT INTO [Account] VALUES ('Movimiento de productos', 'Movimiento de productos', GETDATE(), 'QA_USER')
----------------------------------------------------------INGRESO DE CUENTAS PARA EL EJERCICIO----------------------------------------------------------

--------------------------------------------------------INGRESO DE DOCUMENTOS PARA EL EJERCICIO---------------------------------------------------------
--INSERT INTO [FileInfo] VALUES ('Import_Sum_Export_Subs_MatProd','Cuenta que suma materias primas al inventario por importación y resta productos terminados mediante descargo de materias primas', GETDATE(), 'QA_USER')
--INSERT INTO [FileInfo] VALUES ('Import_Subs_Export_Sum_Prod','Cuenta que resta materias primas al inventario por importación y suma materias primas por medio de importación al inventario', GETDATE(), 'QA_USER')
--INSERT INTO [FileInfo] VALUES ('Import_Sum_Export_Subs_Prod','Cuenta que suma productos terminados al inventario por importación y resta productos terminados por exportación', GETDATE(), 'QA_USER')
--------------------------------------------------------INGRESO DE DOCUMENTOS PARA EL EJERCICIO---------------------------------------------------------

-----------------------------------------------------CONFIGURACION DE DOCUMENTOS PARA EL EJERCICIO------------------------------------------------------
--INSERT INTO [FileInfoConfig] VALUES((SELECT Id FROM [FileInfo] WHERE [Name] = 'Import_Sum_Export_Subs_MatProd'), 
--									(SELECT Id FROM FileInfoType WHERE [Name] = 'Importación'),
--									(SELECT Id FROM [Account] WHERE [Name] = 'Importación estandar'), 1, 0, 1, 1, 
--									GETDATE(), 'QA_USER');
--INSERT INTO [FileInfoConfig] VALUES((SELECT Id FROM [FileInfo] WHERE [Name] = 'Import_Sum_Export_Subs_MatProd'),
--									(SELECT Id FROM FileInfoType WHERE [Name] = 'Exportación'),
--									(SELECT Id FROM [Account] WHERE [Name] = 'Importación estandar'), 1, 1, 1, 1,
--									GETDATE(), 'QA_USER');
--INSERT INTO [FileInfoConfig] VALUES((SELECT Id FROM [FileInfo] WHERE [Name] = 'Import_Subs_Export_Sum_Prod'),
--									(SELECT Id FROM FileInfoType WHERE [Name] = 'Importación'),
--									(SELECT Id FROM [Account] WHERE [Name] = 'Importación extraordinaria'), 1, 1, 1, 1,
--									GETDATE(), 'QA_USER');
--INSERT INTO [FileInfoConfig] VALUES((SELECT Id FROM [FileInfo] WHERE [Name] = 'Import_Subs_Export_Sum_Prod'),
--									(SELECT Id FROM FileInfoType WHERE [Name] = 'Exportación'),
--									(SELECT Id FROM [Account] WHERE [Name] = 'Importación extraordinaria'), 1, 0, 1, 1,
--									GETDATE(), 'QA_USER');
--INSERT INTO [FileInfoConfig] VALUES((SELECT Id FROM [FileInfo] WHERE [Name] = 'Import_Sum_Export_Subs_Prod'),
--									(SELECT Id FROM FileInfoType WHERE [Name] = 'Importación'),
--									(SELECT Id FROM [Account] WHERE [Name] = 'Movimiento de productos'), 1, 0, 0, 1, 
--									GETDATE(), 'QA_USER');
--INSERT INTO [FileInfoConfig] VALUES((SELECT Id FROM [FileInfo] WHERE [Name] = 'Import_Sum_Export_Subs_Prod'),
--									(SELECT Id FROM FileInfoType WHERE [Name] = 'Exportación'),
--									(SELECT Id FROM [Account] WHERE [Name] = 'Movimiento de productos'), 1, 1, 0, 1, 
--									GETDATE(), 'QA_USER');
-----------------------------------------------------CONFIGURACION DE DOCUMENTOS PARA EL EJERCICIO------------------------------------------------------

------------------------------------------------------INGRESO DE NUEVOS CLIENTES PARA EL EJERCICIO------------------------------------------------------
EXEC spi_Customer 'Fosforera de Guatemala S.A.', NULL, 'Representante legal de la fosforera', 990201, 990201, 990202, '2018-03-27', NULL, 'QA_USER'
EXEC spi_Customer 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.', NULL, 'Representante legal de la empresa', 990101, 99010101, 99010102, '2018-03-27', NULL, 'QA_USER'
EXEC spi_Customer 'Repuestos universales centroamericanos para Guatemala s.a.', NULL, 'Representante legal de la importadora', 990301, 990301, 990302, '2018-03-31', NULL, 'QA_USER'

INSERT INTO [CustomerAccount] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Fosforera de Guatemala S.A.'),
										(SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989'), 100, 100, '2017-01-01', '2017-12-31',
										 '2017-01-01', '2017-12-31', GETDATE(), 'QA_USER');
INSERT INTO [CustomerAccount] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Fosforera de Guatemala S.A.'),
										(SELECT Id FROM [Account] WHERE [Name] = 'Constancias'), 100, 100, '2017-01-01', '2017-12-31',
										 '2017-01-01', '2017-12-31', GETDATE(), 'QA_USER');
INSERT INTO [CustomerAccount] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.'),
										(SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989'), 100, 100, '2017-01-01', '2017-12-31',
										 '2017-01-01', '2017-12-31', GETDATE(), 'QA_USER');
INSERT INTO [CustomerAccount] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.'),
										(SELECT Id FROM [Account] WHERE [Name] = 'Constancias'), 100, 100, '2017-01-01', '2017-12-31',
										 '2017-01-01', '2017-12-31', GETDATE(), 'QA_USER');
INSERT INTO [CustomerAccount] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Repuestos universales centroamericanos para Guatemala s.a.'),
										(SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989'), 100, 100, '2017-01-01', '2017-12-31',
										 '2017-01-01', '2017-12-31', GETDATE(), 'QA_USER');
INSERT INTO [CustomerAccount] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Repuestos universales centroamericanos para Guatemala s.a.'),
										(SELECT Id FROM [Account] WHERE [Name] = 'Constancias'), 100, 100, '2017-01-01', '2017-12-31',
										 '2017-01-01', '2017-12-31', GETDATE(), 'QA_USER');

INSERT INTO Phone VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Fosforera de Guatemala S.A.'), 
							(select Id from PhoneType where [Description] = 'Trabajo'),
							23283838, GETDATE(), 'QA_USER')
INSERT INTO Phone VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.'), 
							(select Id from PhoneType where [Description] = 'Trabajo'),
							77644496, GETDATE(), 'QA_USER')
INSERT INTO Phone VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Repuestos universales centroamericanos para Guatemala s.a.'), 
							(select Id from PhoneType where [Description] = 'Trabajo'),
							77648859, GETDATE(), 'QA_USER')

INSERT INTO Email VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Fosforera de Guatemala S.A.'), 
							(select Id from EmailType where [Description] = 'Trabajo'),
							'contacto@fosforeraguatemala.com', GETDATE(), 'QA_USER')
INSERT INTO Email VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.'), 
							(select Id from EmailType where [Description] = 'Trabajo'),
							'contacto@importacionesdiversas.com', GETDATE(), 'QA_USER')
INSERT INTO Email VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Repuestos universales centroamericanos para Guatemala s.a.'), 
							(select Id from EmailType where [Description] = 'Trabajo'),
							'contacto@importadoradecarro.com', GETDATE(), 'QA_USER')

INSERT INTO [Address] VALUES ((select Id from AddressType where [Description] = 'Trabajo'),
							(SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Fosforera de Guatemala S.A.'), 
							'7a calle 13-11 zona 3', GETDATE(), 'QA_USER')
INSERT INTO [Address] VALUES ((select Id from AddressType where [Description] = 'Trabajo'),
							(SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.'), 
							'7a calle 13-11 zona 7', GETDATE(), 'QA_USER')
INSERT INTO [Address] VALUES ((select Id from AddressType where [Description] = 'Trabajo'),
							(SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Repuestos universales centroamericanos para Guatemala s.a.'), 
							'7a calle 13-11 zona 5', GETDATE(), 'QA_USER')

INSERT INTO [CustomerUser] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Fosforera de Guatemala S.A.'), 
									'ddhernandezf', GETDATE(), 'QA_USER')
INSERT INTO [CustomerUser] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.'), 
									'ddhernandezf', GETDATE(), 'QA_USER')
INSERT INTO [CustomerUser] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Repuestos universales centroamericanos para Guatemala s.a.'), 
									'ddhernandezf', GETDATE(), 'QA_USER')
INSERT INTO [CustomerUser] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Fosforera de Guatemala S.A.'), 
									'grangel', GETDATE(), 'QA_USER')
INSERT INTO [CustomerUser] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.'), 
									'grangel', GETDATE(), 'QA_USER')
INSERT INTO [CustomerUser] VALUES ((SELECT Id FROM [Person] WHERE [EnterpriseName] = 'Repuestos universales centroamericanos para Guatemala s.a.'), 
									'grangel', GETDATE(), 'QA_USER')
------------------------------------------------------INGRESO DE NUEVOS CLIENTES PARA EL EJERCICIO------------------------------------------------------

----------------------------------------------------------UNIDADES DE MEDIDA PARA EL EJERCICIO----------------------------------------------------------
INSERT INTO [UnitMeasurement] VALUES ('Unidades', 'Unidades', 'UN', GETDATE(), 'QA_USER')
----------------------------------------------------------UNIDADES DE MEDIDA PARA EL EJERCICIO----------------------------------------------------------

-------------------------------------------------------------RESOLUCIONES PARA EL EJERCICIO-------------------------------------------------------------
INSERT INTO [Resolution] VALUES ((SELECT Id FROM [Person] WHERE EnterpriseName = 'Fosforera de Guatemala S.A.'),
								(SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989'), 
								'Productos terminados', 'Resolución para productos terminados', '2017-03-27', GETDATE(), 'QA_USER')
INSERT INTO [Resolution] VALUES ((SELECT Id FROM [Person] WHERE EnterpriseName = 'Fosforera de Guatemala S.A.'),
								(SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989'), 
								'Materias primas', 'Resolución para materias primas', '2017-03-28', GETDATE(), 'QA_USER')

INSERT INTO [Resolution] VALUES ((SELECT Id FROM [Person] WHERE EnterpriseName = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.'),
								(SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989'), 
								'Carros', NULL, '2017-03-28', GETDATE(), 'QA_USER')
INSERT INTO [Resolution] VALUES ((SELECT Id FROM [Person] WHERE EnterpriseName = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.'),
								(SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989'), 
								'Respuestos', NULL, '2017-03-28', GETDATE(), 'QA_USER')

INSERT INTO [Resolution] VALUES ((SELECT Id FROM [Person] WHERE EnterpriseName = 'Repuestos universales centroamericanos para Guatemala s.a.'),
								(SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989'), 
								'Repuestos', NULL, '2017-03-28', GETDATE(), 'QA_USER')

INSERT INTO [ResolutionAccountingItem] VALUES ((select Id from Resolution where [Name] = 'Productos terminados' and IdCustomer = (SELECT Id FROM [Person] WHERE EnterpriseName = 'Fosforera de Guatemala S.A.') and IdAccount = (SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989')), 
												(SELECT Id FROM AccountingItem WHERE [Description] = '- - - De uso domestico' and AccountingItem = '8508.11.10.00'))
INSERT INTO [ResolutionAccountingItem] VALUES ((select Id from Resolution where [Name] = 'Materias primas' and IdCustomer = (SELECT Id FROM [Person] WHERE EnterpriseName = 'Fosforera de Guatemala S.A.') and IdAccount = (SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989')), 
												(SELECT Id FROM AccountingItem WHERE [Description] = '- - - Palillos para la fabricacion de fosforos' and AccountingItem = '4421.91.20.00'))
INSERT INTO [ResolutionAccountingItem] VALUES ((select Id from Resolution where [Name] = 'Materias primas' and IdCustomer = (SELECT Id FROM [Person] WHERE EnterpriseName = 'Fosforera de Guatemala S.A.') and IdAccount = (SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989')), 
												(SELECT Id FROM AccountingItem WHERE [Description] = 'FOSFOROS (CERILLAS) EXCEPTO LOS ARTICULOS DE PIROTECNIA DE LA PARTIDA 36.04'))

INSERT INTO [ResolutionAccountingItem] VALUES ((select Id from Resolution where [Name] = 'Carros' and IdCustomer = (SELECT Id FROM [Person] WHERE EnterpriseName = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.') and IdAccount = (SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989')), 
												(SELECT Id FROM AccountingItem WHERE [Description] = '- - Concebidos para montarlos sobre vehiculos de carretera' and AccountingItem = '8426.91.00.00'))
INSERT INTO [ResolutionAccountingItem] VALUES ((select Id from Resolution where [Name] = 'Respuestos' and IdCustomer = (SELECT Id FROM [Person] WHERE EnterpriseName = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.') and IdAccount = (SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989')), 
												(SELECT Id FROM AccountingItem WHERE [Description] = '- Las demas guarniciones herrajes y articulos similares para vehiculos automoviles' and AccountingItem = '8302.30.00.00'))

INSERT INTO [ResolutionAccountingItem] VALUES ((select Id from Resolution where [Name] = 'Repuestos' and IdCustomer = (SELECT Id FROM [Person] WHERE EnterpriseName = 'Repuestos universales centroamericanos para Guatemala s.a.') and IdAccount = (SELECT Id FROM [Account] WHERE [Name] = 'Cta cte 2989')), 
												(SELECT Id FROM AccountingItem WHERE [Description] = '- Las demas guarniciones herrajes y articulos similares para vehiculos automoviles' and AccountingItem = '8302.30.00.00'))
-------------------------------------------------------------RESOLUCIONES PARA EL EJERCICIO-------------------------------------------------------------

-------------------------------------------INGRESO DE PRODUCTOS, MATERIAS PRIMAS Y FORMULAS PARA EL EJERCICIO-------------------------------------------
DECLARE @Fosforera		INT,
		@Importacion	INT,
		@Respuestos		INT;

DECLARE	@ResProdTerm	INT,
		@ResMatPrim		INT,
		@ResCarImport	INT,
		@ResRepImport	INT,
		@ResRepRepues	INT;

DECLARE	@AccFosforo		INT,
		@AccDomestico	INT,
		@AccRepuesto	INT,
		@AccVehiculo	INT;

DECLARE	@Milim			INT,
		@Onzas			INT,
		@Centi			INT,
		@Unidad			INT;

SELECT @Fosforera = Id FROM [Person] WHERE [EnterpriseName] = 'Fosforera de Guatemala S.A.';
SELECT @Importacion = Id FROM [Person] WHERE EnterpriseName = 'Importaciones diversas de la ciudad de Guatemala y centroamerica s.a.';
SELECT @Respuestos = Id FROM [Person] WHERE EnterpriseName = 'Repuestos universales centroamericanos para Guatemala s.a.';

SELECT @ResProdTerm = Id FROM [Resolution] WHERE [Name] = 'Productos terminados';
SELECT @ResMatPrim = Id FROM [Resolution] WHERE [Name] = 'Materias primas';

SELECT @ResProdTerm = Id FROM Resolution WHERE IdCustomer = @Fosforera AND [Name] = 'Productos terminados'
SELECT @ResMatPrim = Id FROM Resolution WHERE IdCustomer = @Fosforera AND [Name] = 'Materias primas'
SELECT @ResCarImport = Id FROM Resolution WHERE IdCustomer = @Importacion AND [Name] = 'Carros'
SELECT @ResRepImport = Id FROM Resolution WHERE IdCustomer = @Importacion AND [Name] = 'Respuestos'
SELECT @ResRepRepues = Id FROM Resolution WHERE IdCustomer = @Respuestos AND [Name] = 'Repuestos'

SELECT @AccFosforo = Id FROM [AccountingItem] WHERE [Description] = 'FOSFOROS (CERILLAS) EXCEPTO LOS ARTICULOS DE PIROTECNIA DE LA PARTIDA 36.04' AND AccountingItem='3605.00.00.00';
SELECT @AccDomestico = Id FROM [AccountingItem] WHERE [Description] = '- - - De uso domestico' AND AccountingItem = '8508.11.10.00';
SELECT @AccRepuesto = Id FROM [AccountingItem] WHERE [Description] = '- Las demas guarniciones herrajes y articulos similares para vehiculos automoviles' AND AccountingItem = '8302.30.00.00';
SELECT @AccVehiculo = Id FROM [AccountingItem] WHERE [Description] = '- - Concebidos para montarlos sobre vehiculos de carretera' AND AccountingItem = '8426.91.00.00';

SELECT @Milim = Id FROM [UnitMeasurement] WHERE [Name] = 'Mililitros';
SELECT @Onzas = Id FROM [UnitMeasurement] WHERE [Name] = 'Onzas';
SELECT @Centi = Id FROM [UnitMeasurement] WHERE [Name] = 'Centimetros';
SELECT @Unidad = Id FROM [UnitMeasurement] WHERE [Name] = 'Unidades';

INSERT INTO [Item] VALUES (@Fosforera, @ResMatPrim, @AccFosforo, @Unidad, 1001004 ,'Palillos para fósforos', 'Palillos para la elaboración de fósforos', null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Fosforera, @ResMatPrim, @AccFosforo, @Onzas, 1001005 ,'Polvora', 'pólvora para serillo', null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Fosforera, @ResMatPrim, @AccFosforo, @Milim, 1001006 ,'Colorante rosado para polvora', NULL, null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Fosforera, @ResMatPrim, @AccFosforo, @Centi, 1001006 ,'Cartón para caja de fósforos', NULL, null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Fosforera, @ResMatPrim, @AccFosforo, @Centi, 1001007 ,'Abrasivo', 'Lija para encender fósforos', null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Fosforera, @ResMatPrim, @AccFosforo, @Centi, 1001008 ,'Celofán transparente', NULL, null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Fosforera, @ResProdTerm, @AccDomestico, @Unidad, 1001001 ,'Fósforos Paquete de 10', 'Paquete que contiene 10 cajas de fosforos', null, 1, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Fosforera, @ResProdTerm, @AccDomestico, @Unidad, 1001002 ,'Fósforos Paquete de 25', 'Paquete de 25 cajas de fósforos', null, 1, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Fosforera, @ResProdTerm, @AccDomestico, @Unidad, 1001003 ,'Fósforos Paquete de 100', 'Presentación en paquetes de 100', null, 1, GETDATE(), 'QA_USER');

INSERT INTO [Item] VALUES (@Importacion, @ResRepImport, @AccRepuesto, @Unidad, 1002001 ,'Solenoide Nissan', 'Solenoide de carros nissan', null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Importacion, @ResRepImport, @AccRepuesto, @Unidad, 1002002 ,'Radiadores Toyota', 'Radiadores de carros toyota', null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Importacion, @ResRepImport, @AccRepuesto, @Unidad, 1002003 ,'Radiadores Nissan', 'Radiadores para carros Nissan', null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Importacion, @ResRepImport, @AccRepuesto, @Unidad, 1002004 ,'Filtro de aire Toyota', null, null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Importacion, @ResRepImport, @AccRepuesto, @Unidad, 1002005 ,'Filtro de aire Nissan', null, null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Importacion, @ResRepImport, @AccRepuesto, @Unidad, 1001006 ,'Solenoide Toyota', null, null, 0, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Importacion, @ResCarImport, @AccVehiculo, @Unidad, 1001007 ,'Toyota Yaris', null, null, 1, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Importacion, @ResCarImport, @AccVehiculo, @Unidad, 1001008 ,'Nissan March', '1001008', null, 1, GETDATE(), 'QA_USER');

INSERT INTO [Item] VALUES (@Respuestos, @ResRepRepues, @AccRepuesto, @Unidad, 1003001 ,'Asientos toyota yaris 2010 - 2013', null, null, 1, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Respuestos, @ResRepRepues, @AccRepuesto, @Unidad, 1003002 ,'Retrovisores Nissan March 2016', null, null, 1, GETDATE(), 'QA_USER');
INSERT INTO [Item] VALUES (@Respuestos, @ResRepRepues, @AccRepuesto, @Unidad, 1003003 ,'Llantan Ring 26', null, null, 1, GETDATE(), 'QA_USER');

DECLARE @ProdFosf10		INT,
		@ProdFosf25		INT,
		@ProdFosf100	INT,
		@MatPalillos	INT,
		@MatColorante	INT,
		@MatPolvora		INT,
		@MatCarton		INT,
		@MatAbrasivo	INT,
		@MatCelofan		INT;

DECLARE @SoleNissan		INT,
		@SoleToyota		INT,
		@RadiaNissan	INT,
		@RadiaToyota	INT,
		@FiltroNissan	INT,
		@FiltroToyota	INT,
		@ToyotaYaris	INT,
		@NissanMarch	INT;

DECLARE @AsientoYaris	INT,
		@RetroNissan	INT,
		@LlantasRing	INT;

SELECT @MatPalillos = Id FROM [Item] WHERE [Name] = 'Palillos para fósforos' AND IdCustomer = @Fosforera;
SELECT @MatPolvora = Id FROM [Item] WHERE [Name] = 'Polvora'  AND IdCustomer = @Fosforera;
SELECT @MatColorante = Id FROM [Item] WHERE [Name] = 'Colorante rosado para polvora' AND IdCustomer = @Fosforera;
SELECT @MatCarton = Id FROM [Item] WHERE [Name] = 'Cartón para caja de fósforos'  AND IdCustomer = @Fosforera;
SELECT @MatAbrasivo = Id FROM [Item] WHERE [Name] = 'Abrasivo'  AND IdCustomer = @Fosforera;
SELECT @MatCelofan = Id FROM [Item] WHERE [Name] = 'Celofán transparente'  AND IdCustomer = @Fosforera;
SELECT @ProdFosf10 = Id FROM [Item] WHERE [Name] = 'Fósforos Paquete de 10'  AND IdCustomer = @Fosforera;
SELECT @ProdFosf25 = Id FROM [Item] WHERE [Name] = 'Fósforos Paquete de 25'  AND IdCustomer = @Fosforera;
SELECT @ProdFosf100 = Id FROM [Item] WHERE [Name] = 'Fósforos Paquete de 100'  AND IdCustomer = @Fosforera;

SELECT @SoleNissan = Id FROM [Item] WHERE [Name] = 'Solenoide Nissan' AND IdCustomer = @Importacion;
SELECT @SoleToyota = Id FROM [Item] WHERE [Name] = 'Solenoide Toyota' AND IdCustomer = @Importacion;
SELECT @RadiaToyota = Id FROM [Item] WHERE [Name] = 'Radiadores Toyota' AND IdCustomer = @Importacion;
SELECT @RadiaNissan = Id FROM [Item] WHERE [Name] = 'Radiadores Nissan' AND IdCustomer = @Importacion;
SELECT @FiltroToyota = Id FROM [Item] WHERE [Name] = 'Filtro de aire Toyota' AND IdCustomer = @Importacion;
SELECT @FiltroNissan = Id FROM [Item] WHERE [Name] = 'Filtro de aire Nissan' AND IdCustomer = @Importacion;
SELECT @ToyotaYaris = Id FROM [Item] WHERE [Name] = 'Toyota Yaris' AND IdCustomer = @Importacion;
SELECT @NissanMarch = Id FROM [Item] WHERE [Name] = 'Nissan March' AND IdCustomer = @Importacion;

SELECT @AsientoYaris = Id FROM [Item] WHERE [Name] = 'Asientos toyota yaris 2010 - 2013' AND IdCustomer = @Respuestos;
SELECT @RetroNissan = Id FROM [Item] WHERE [Name] = 'Retrovisores Nissan March 2016' AND IdCustomer = @Respuestos;
SELECT @LlantasRing = Id FROM [Item] WHERE [Name] = 'Llantan Ring 26' AND IdCustomer = @Respuestos;

INSERT INTO [Formula] VALUES(@ProdFosf10, @MatPalillos, 10, 0, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf10, @MatPolvora, 10, 5, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf10, @MatColorante, 5, 1.2, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf10, @MatCarton, 140, 9, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf10, @MatAbrasivo, 20, 1, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf10, @MatCelofan, 160, 0, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf25, @MatPalillos, 625, 0, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf25, @MatPolvora, 25, 12.5, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf25, @MatColorante, 12.5, 3, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf25, @MatCarton, 350, 22.5, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf25, @MatAbrasivo, 50, 2.5, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf25, @MatCelofan, 400, 0, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf100, @MatPalillos, 2500, 0, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf100, @MatPolvora, 100, 50, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf100, @MatColorante, 50, 12, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf100, @MatCarton, 1400, 90, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf100, @MatAbrasivo, 200, 10, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ProdFosf100, @MatCelofan, 1600, 0, GETDATE(), 'QA_USER');

INSERT INTO [Formula] VALUES(@NissanMarch, @FiltroNissan, 1, 0, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@NissanMarch, @RadiaNissan, 1, 0, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@NissanMarch, @SoleNissan, 1, 0, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ToyotaYaris, @FiltroToyota, 1, 0, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ToyotaYaris, @RadiaToyota, 1, 0, GETDATE(), 'QA_USER');
INSERT INTO [Formula] VALUES(@ToyotaYaris, @SoleToyota, 1, 0, GETDATE(), 'QA_USER');
-------------------------------------------INGRESO DE PRODUCTOS, MATERIAS PRIMAS Y FORMULAS PARA EL EJERCICIO-------------------------------------------

----------------------------------------ASIGNACIÓN DE CAMPOS A LOS DOCUMENTOS DE CONFIGURACIÓN PARA EL EJERCICIO----------------------------------------
--DECLARE	@AccEstanImpo	INT,
--		@AccExtraImpo	INT,
--		@AccMovProduc	INT;

--DECLARE	@FtImport	INT,
--		@FtExport	INT;

--DECLARE	@FiImportNormMatProd	INT,
--		@FiImportExtrMatProd	INT,
--		@FiImportNormPrdo		INT;
		
--SELECT @AccEstanImpo = Id FROM [Account] WHERE [Name] = 'Importación estandar';
--SELECT @AccExtraImpo = Id FROM [Account] WHERE [Name] = 'Importación extraordinaria';
--SELECT @AccMovProduc = Id FROM [Account] WHERE [Name] = 'Movimiento de productos';

--SELECT @FtImport = Id FROM [FileInfoType] WHERE [Name] = 'Importación';
--SELECT @FtExport = Id FROM [FileInfoType] WHERE [Name] = 'Exportación';

--SELECT @FiImportNormMatProd = Id FROM FileInfo WHERE [Name] = 'Import_Sum_Export_Subs_MatProd';
--SELECT @FiImportExtrMatProd = Id FROM FileInfo WHERE [Name] = 'Import_Subs_Export_Sum_Prod';
--SELECT @FiImportNormPrdo = Id FROM FileInfo WHERE [Name] = 'Import_Sum_Export_Subs_Prod';

--DECLARE	@FicImpStandImp	INT,
--		@FicImpStandExp	INT,
--		@FicImpExtImp	INT,
--		@FicImpExtExp	INT,
--		@FicMovImp		INT,
--		@FicMovExp		INT;

--SELECT @FicImpStandImp = Id FROM [FileInfoConfig] WHERE IdFileInfo = @FiImportNormMatProd AND IdFileType = @FtImport AND IdAccount = @AccEstanImpo;
--SELECT @FicImpStandExp = Id FROM [FileInfoConfig] WHERE IdFileInfo = @FiImportNormMatProd AND IdFileType = @FtExport AND IdAccount = @AccEstanImpo;
--SELECT @FicImpExtImp = Id FROM [FileInfoConfig] WHERE IdFileInfo = @FiImportExtrMatProd AND IdFileType = @FtImport AND IdAccount = @AccExtraImpo;
--SELECT @FicImpExtExp = Id FROM [FileInfoConfig] WHERE IdFileInfo = @FiImportExtrMatProd AND IdFileType = @FtExport AND IdAccount = @AccExtraImpo;
--SELECT @FicMovImp = Id FROM [FileInfoConfig] WHERE IdFileInfo = @FiImportNormPrdo AND IdFileType = @FtImport AND IdAccount = @AccMovProduc;
--SELECT @FicMovExp = Id FROM [FileInfoConfig] WHERE IdFileInfo = @FiImportNormPrdo AND IdFileType = @FtExport AND IdAccount = @AccMovProduc;

--DECLARE @IdDocument			INT,
--		@AuthorizationDate	INT,
--		@IdCountry			INT,
--		@IdCustom			INT;

--DECLARE	@ItemQuantity	INT,
--		@IdItem			INT;

--DECLARE	@IdSupplier		INT,
--		@AttachedNumber	INT,
--		@AttachedDate	INT,
--		@Description	INT;

--SELECT @IdDocument = Id FROM [Fields] WHERE DataBaseName = 'IdDocument' AND IdTable = (SELECT Id FROM [Table] WHERE [Name] = 'FileHeader');
--SELECT @AuthorizationDate = Id FROM [Fields] WHERE DataBaseName = 'AuthorizationDate' AND IdTable = (SELECT Id FROM [Table] WHERE [Name] = 'FileHeader');
--SELECT @IdCountry = Id FROM [Fields] WHERE DataBaseName = 'IdCountry' AND IdTable = (SELECT Id FROM [Table] WHERE [Name] = 'FileHeader');
--SELECT @IdCustom = Id FROM [Fields] WHERE DataBaseName = 'IdCustom' AND IdTable = (SELECT Id FROM [Table] WHERE [Name] = 'FileHeader');


--SELECT @ItemQuantity = Id FROM [Fields] WHERE DataBaseName = 'ItemQuantity' AND IdTable = (SELECT Id FROM [Table] WHERE [Name] = 'FileDetail');
--SELECT @IdItem = Id FROM [Fields] WHERE DataBaseName = 'IdItem' AND IdTable = (SELECT Id FROM [Table] WHERE [Name] = 'FileDetail');

--SELECT @IdSupplier = Id FROM [Fields] WHERE DataBaseName = 'IdSupplier' AND IdTable = (SELECT Id FROM [Table] WHERE [Name] = 'FileAttached');
--SELECT @AttachedNumber = Id FROM [Fields] WHERE DataBaseName = 'AttachedNumber' AND IdTable = (SELECT Id FROM [Table] WHERE [Name] = 'FileAttached');
--SELECT @AttachedDate = Id FROM [Fields] WHERE DataBaseName = 'AttachedDate' AND IdTable = (SELECT Id FROM [Table] WHERE [Name] = 'FileAttached');
--SELECT @Description = Id FROM [Fields] WHERE DataBaseName = 'Description' AND IdTable = (SELECT Id FROM [Table] WHERE [Name] = 'FileAttached');

--INSERT INTO [FileMasterDisplay] VALUES (@FicImpStandImp, @IdDocument, 'No. Docto', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpStandImp, @AuthorizationDate, 'Fec. Autorización', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpStandImp, @IdCountry, 'País', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpStandImp, @IdCustom, 'Aduana', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicImpStandImp, @ItemQuantity, 'Cantidad', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicImpStandImp, @IdItem, 'Materia prima', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpStandImp, @IdSupplier, 'Proveedor', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpStandImp, @AttachedNumber, 'No. Factura', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpStandImp, @AttachedDate, 'Fecha', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpStandImp, @Description, 'Descripción', 1, 0, GETDATE(), 'QA_USER');

--INSERT INTO [FileMasterDisplay] VALUES (@FicImpStandExp, @IdDocument, 'No. Docto', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpStandExp, @AuthorizationDate, 'Fec. Autorización', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpStandExp, @IdCountry, 'País', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpStandExp, @IdCustom, 'Aduana', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicImpStandExp, @ItemQuantity, 'Cantidad', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicImpStandExp, @IdItem, 'Materia prima', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpStandExp, @IdSupplier, 'Proveedor', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpStandExp, @AttachedNumber, 'No. Factura', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpStandExp, @AttachedDate, 'Fecha', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpStandExp, @Description, 'Descripción', 1, 0, GETDATE(), 'QA_USER');

--INSERT INTO [FileMasterDisplay] VALUES (@FicImpExtImp, @IdDocument, 'No. Docto', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpExtImp, @AuthorizationDate, 'Fec. Autorización', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpExtImp, @IdCountry, 'País', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpExtImp, @IdCustom, 'Aduana', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicImpExtImp, @ItemQuantity, 'Cantidad', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicImpExtImp, @IdItem, 'Producto', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpExtImp, @IdSupplier, 'Proveedor', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpExtImp, @AttachedNumber, 'No. Factura', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpExtImp, @AttachedDate, 'Fecha', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpExtImp, @Description, 'Descripción', 1, 0, GETDATE(), 'QA_USER');

--INSERT INTO [FileMasterDisplay] VALUES (@FicImpExtExp, @IdDocument, 'No. Docto', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpExtExp, @AuthorizationDate, 'Fec. Autorización', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpExtExp, @IdCountry, 'País', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicImpExtExp, @IdCustom, 'Aduana', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicImpExtExp, @ItemQuantity, 'Cantidad', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicImpExtExp, @IdItem, 'Materia prima', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpExtExp, @IdSupplier, 'Proveedor', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpExtExp, @AttachedNumber, 'No. Factura', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpExtExp, @AttachedDate, 'Fecha', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicImpExtExp, @Description, 'Descripción', 1, 0, GETDATE(), 'QA_USER');

--INSERT INTO [FileMasterDisplay] VALUES (@FicMovImp, @IdDocument, 'No. Docto', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicMovImp, @AuthorizationDate, 'Fec. Autorización', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicMovImp, @IdCountry, 'País', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicMovImp, @IdCustom, 'Aduana', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicMovImp, @ItemQuantity, 'Cantidad', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicMovImp, @IdItem, 'Materia prima', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicMovImp, @IdSupplier, 'Proveedor', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicMovImp, @AttachedNumber, 'No. Factura', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicMovImp, @AttachedDate, 'Fecha', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicMovImp, @Description, 'Descripción', 1, 0, GETDATE(), 'QA_USER');

--INSERT INTO [FileMasterDisplay] VALUES (@FicMovExp, @IdDocument, 'No. Docto', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicMovExp, @AuthorizationDate, 'Fec. Autorización', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicMovExp, @IdCountry, 'País', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileMasterDisplay] VALUES (@FicMovExp, @IdCustom, 'Aduana', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicMovExp, @ItemQuantity, 'Cantidad', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileDetailDisplay] VALUES (@FicMovExp, @IdItem, 'Materia prima', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicMovExp, @IdSupplier, 'Proveedor', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicMovExp, @AttachedNumber, 'No. Factura', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicMovExp, @AttachedDate, 'Fecha', 1, 1, GETDATE(), 'QA_USER');
--INSERT INTO [FileAttachedDisplay] VALUES (@FicMovExp, @Description, 'Descripción', 1, 0, GETDATE(), 'QA_USER');
----------------------------------------ASIGNACIÓN DE CAMPOS A LOS DOCUMENTOS DE CONFIGURACIÓN PARA EL EJERCICIO----------------------------------------