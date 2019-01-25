EXEC spi_FileInfo 'Factura', NULL, 'SYS_USER';

DECLARE @Import	INT,
		@Export	INT,
		@DUA	INT,
		@FAUCA	INT,
		@FACT	INT,
		@NAC	INT,
		@DESTC	INT,
		@POLIZA	INT,
		@Account2989	INT,
		@AccountCONST	INT
		
SELECT @Import = Id FROM [FileInfoType] WHERE [Name] = 'Importación';
SELECT @Export = Id FROM [FileInfoType] WHERE [Name] = 'Exportación';

SELECT @DUA = Id FROM [FileInfo] WHERE [Name] = 'DUA';
SELECT @FAUCA = Id FROM [FileInfo] WHERE [Name] = 'FAUCA';
SELECT @FACT = Id FROM [FileInfo] WHERE [Name] = 'Factura';
SELECT @NAC = Id FROM [FileInfo] WHERE [Name] = 'Nacionalización';
SELECT @DESTC = Id FROM [FileInfo] WHERE [Name] = 'Acta Destrucción';
SELECT @POLIZA = Id FROM [FileInfo] WHERE [Name] = 'Póliza';

SELECT @Account2989 = Id FROM [Account] WHERE [Name] = 'Cta cte 2989';
SELECT @AccountCONST = Id FROM [Account] WHERE [Name] = 'Constancias';

EXEC spi_FileInfoConfig @DUA, @Export, @AccountCONST, 0, 1, 1, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @FAUCA, @Export, @AccountCONST, 0, 1, 1, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @FACT, @Import, @AccountCONST, 0, 0, 1, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @NAC, @Export, @AccountCONST, 0, 1, 1, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @DESTC, @Export, @AccountCONST, 0, 1, 1, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @POLIZA, @Export, @AccountCONST, 0, 1, 1, 1, 'SYS_USER'

DECLARE	@2989		INT,
			@Constancia	INT;
			
 SELECT @2989 = Id FROM [Account] WHERE [Name] = 'Cta cte 2989';
 SELECT @Constancia = Id FROM [Account] WHERE [Name] = 'Constancias';

 DECLARE @DuaImport_2989		INT,
		 @DuaExport_2989		INT,
		 --@FactImport_2989		INT,
		 @FaucaExport_2989		INT,
		 @NacExport_2989		INT,
		 @DestcExport_2989		INT,
		 --@DuaImport_const		INT,
		 @DuaExport_const		INT,
		 @FactImport_const		INT,
		 @FaucaExport_const		INT,
		 @NacExport_const		INT,
		 @DestcExport_const		INT
		 
SELECT @DuaExport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @DUA AND IdFileType  = @Export;
SELECT @FactImport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @FACT AND IdFileType  = @Import;
SELECT @FaucaExport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @FAUCA AND IdFileType  = @Export;
SELECT @NacExport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @NAC AND IdFileType  = @Export;
SELECT @DestcExport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @DESTC AND IdFileType  = @Export;

DECLARE	@IdDocument			INT,
		@IdCustom			INT,
		@AutorizationDate	INT,
		@IdCountry			INT,
		@ExchangeRate		INT,
		@CifTotal			INT,
		@LinesTotal			INT,
		@IdWarranty			INT,
		@Insurance			INT,
		@Cargo				INT

SELECT @IdDocument = Id FROM Fields WHERE IdTable = 1 AND DataBaseName = 'IdDocument';
SELECT @IdCustom = Id FROM Fields WHERE IdTable = 1 AND DataBaseName = 'IdCustom';
SELECT @AutorizationDate = Id FROM Fields WHERE IdTable = 1 AND DataBaseName = 'AuthorizationDate';
SELECT @IdCountry = Id FROM Fields WHERE IdTable = 1 AND DataBaseName = 'IdCountry';
SELECT @ExchangeRate = Id FROM Fields WHERE IdTable = 1 AND DataBaseName = 'ExchangeRate';
SELECT @CifTotal = Id FROM Fields WHERE IdTable = 1 AND DataBaseName = 'CIFTotal';
SELECT @LinesTotal = Id FROM Fields WHERE IdTable = 1 AND DataBaseName = 'LinesTotal';
SELECT @IdWarranty = Id FROM Fields WHERE IdTable = 1 AND DataBaseName = 'IdWarranty';
SELECT @Insurance = Id FROM Fields WHERE IdTable = 1 AND DataBaseName = 'Insurance';
SELECT @Cargo = Id FROM Fields WHERE IdTable = 1 AND DataBaseName = 'Cargo';

EXEC spi_FileMasterDisplay @DuaExport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @FaucaExport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @FactImport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER' 

EXEC spi_FileMasterDisplay @NacExport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @NacExport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @DestcExport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DestcExport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'

DECLARE	@TransactionLine	INT,
		@ItemQuantity		INT,
		@IdItem				INT,
		@CIFcostQuetzal		INT,
		@FOcostQuetzal		INT,
		@CIFcostDollar		INT,
		@FOcostDollar		INT,
		@CustomDuties		INT,
		@Iva				INT,
		@TaxableBase		INT,
		@TaxRate			INT,
		@NetWeight			INT,
		@GrossWeight		INT

SELECT @TransactionLine = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'TransactionLine'
SELECT @ItemQuantity = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'ItemQuantity'
SELECT @IdItem = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'IdItem'
SELECT @CIFcostQuetzal = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'CIFcostQuetzal'
SELECT @FOcostQuetzal = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'FOcostQuetzal'
SELECT @CIFcostDollar = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'CIFcostDollar'
SELECT @FOcostDollar = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'FOcostDollar'
SELECT @CustomDuties = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'CustomDuties'
SELECT @Iva = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'Iva'
SELECT @TaxableBase = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'TaxableBase'
SELECT @TaxRate = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'TaxRate'
SELECT @NetWeight = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'NetWeight'
SELECT @GrossWeight = Id FROM Fields WHERE IdTable = 2 AND DataBaseName = 'GrossWeight'

EXEC spi_FileDetailDisplay @NacExport_const, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @CIFcostQuetzal, 'CIF Q', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @FOcostQuetzal, 'FOB Q', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @CIFcostDollar, 'CIF $', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @FOcostDollar, 'FOB $', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @CustomDuties, 'DAI', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @Iva, 'IVA', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @TaxableBase, 'Base Imponible', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @TaxRate, 'Tasa Impositiva', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @NetWeight, 'Peso Neto', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_const, @GrossWeight, 'Peso Bruto', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @DuaExport_const, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaExport_const, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaExport_const, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @FaucaExport_const, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @FaucaExport_const, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @FaucaExport_const, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @FactImport_const, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @FactImport_const, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @FactImport_const, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @DestcExport_const, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DestcExport_const, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DestcExport_const, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

DECLARE	@IdSupplier		INT,
		@Description	INT,
		@AttachedNumber	INT,
		@AttachedDate	INT
		
SELECT @IdSupplier = Id FROM Fields WHERE IdTable = 3 AND DataBaseName = 'IdSupplier'
SELECT @Description = Id FROM Fields WHERE IdTable = 3 AND DataBaseName = 'Description'
SELECT @AttachedNumber = Id FROM Fields WHERE IdTable = 3 AND DataBaseName = 'AttachedNumber'
SELECT @AttachedDate = Id FROM Fields WHERE IdTable = 3 AND DataBaseName = 'AttachedDate'