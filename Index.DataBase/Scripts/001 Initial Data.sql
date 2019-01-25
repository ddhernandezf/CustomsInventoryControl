-------------------------------------------------------------------INSERTANDO MENU-------------------------------------------------------------------
DECLARE	@IdCatalogos	INT,
		@IdFiguras		INT,
		@IdSeguridad	INT,
		@IdUsuarios		INT,
		@IdRol			INT,
		@IdMovimiento	INT,
		@IdProc			INT,
		@IdCliente		INT,
		@IdDocto		INT,
		@IdReportes		INT,
		@IdTransaccion	INT;

INSERT INTO [Premission] VALUES('Teléfonos','',null,'Telefono','Index',null,0,'Telefono.png',0,0, 0);

INSERT INTO [Premission] VALUES('Catálogos','',null,null,null,null,0,'Mantenimientos.png',1,0, 0);
SET @IdCatalogos = (SELECT Id FROM [Premission] WHERE Name = 'Catálogos');

INSERT INTO [Premission] VALUES('Figuras','',null,null,null,null,@IdCatalogos,'Figuras.png',1,0, 0);
SET @IdFiguras = (SELECT Id FROM [Premission] WHERE Name = 'Figuras');

INSERT INTO [Premission] VALUES('Clientes','',null,'Cliente','Index',null,@IdFiguras,'Cliente.png',1,0, 0);
SET @IdCliente = (SELECT Id FROM [Premission] WHERE Name = 'Clientes');
INSERT INTO [Premission] VALUES('Asignar cuenta','',null,'Cliente','AsignarCuenta',null,@IdCliente,'Cuenta.png',0,0, 0);
INSERT INTO [Premission] VALUES('Alta de usuario','',null,'Cliente','Alta',null,@IdCliente,'AltaUsuario.png',0,0, 0);

INSERT INTO [Premission] VALUES('Proveedores','',null,'Proveedor','Index',null,@IdFiguras,'Proveedor.png',1,1, 0);
INSERT INTO [Premission] VALUES('Cliente Destino','',null,'ClienteDestino','Index',null,@IdFiguras,'ClienteDestino.png',1,1, 0);

INSERT INTO [Premission] VALUES('País','',null,'Pais','Index',null,@IdCatalogos,'Country.png',1,1, 0);
INSERT INTO [Premission] VALUES('Moneda','',null,'Moneda','Index',null,@IdCatalogos,'Moneda.png',1,2, 0);
INSERT INTO [Premission] VALUES('Bodega','',null,'Bodega','Index',null,@IdCatalogos,'Bodega.png',1,3, 0);
INSERT INTO [Premission] VALUES('Aduana','',null,'Aduana','Index',null,@IdCatalogos,'Aduana.png',1,4, 0);
INSERT INTO [Premission] VALUES('Cuentas','',null,'Cuenta','Index',null,@IdCatalogos,'Cuentas.png',1,5, 0);
INSERT INTO [Premission] VALUES('Unidad medida','',null,'UnidadMedida','Index',null,@IdCatalogos,'UnidadMedida.png',1,6, 0);
INSERT INTO [Premission] VALUES('Garantías','',null,'Garantia','Index',null,@IdCatalogos,'Garantia.png',1,7, 0);

INSERT INTO [Premission] VALUES('Seguridad','',null,null,null,null,0,'Seguridad.png',1,1, 0);
SET @IdSeguridad = (SELECT Id FROM [Premission] WHERE Name = 'Seguridad');

INSERT INTO [Premission] VALUES('Usuarios','',null,'Usuario','Index',null,@IdSeguridad,'Usuarios.png',1,0, 0);
INSERT INTO [Premission] VALUES('Roles','',null,'Rol','Index',null,@IdSeguridad,'Roles.png',1,1, 0);
SET @IdUsuarios = (SELECT Id FROM [Premission] WHERE Name = 'Usuarios');
SET @IdRol = (SELECT Id FROM [Premission] WHERE Name = 'Roles');

INSERT INTO [Premission] VALUES('Asignar Rol','',null,'Usuario','AsignarlRol',null,@IdUsuarios,'Roles.png',0,0, 0);
INSERT INTO [Premission] VALUES('Asignar Clientes','',null,'Usuario','AsignarlCliente',null,@IdUsuarios,'Cliente.png',0,0, 0);
INSERT INTO [Premission] VALUES('Asignar Permisos','',null,'Rol','AsignarPermiso',null,@IdRol,'Permisos.png',0,0, 0);

INSERT INTO [Premission] VALUES('Ingresos','',null,null,null,null,0,'Procesos.png',1,2, 0);
SET @IdMovimiento = (SELECT Id FROM [Premission] WHERE Name = 'Ingresos');

INSERT INTO [Premission] VALUES('Resoluciones','',null,'Resolucion','Index',null,@IdMovimiento,'Resolucion.png',1,0, 1);
INSERT INTO [Premission] VALUES('Partidas','',null,'Partida','Index',null,@IdMovimiento,'Partida.png',0,0, 1);
INSERT INTO [Premission] VALUES('Conf. Doctos','',null,null,null,null,@IdMovimiento,'DoctoPadre.png',1,1, 1);

SET @IdDocto = (SELECT Id FROM [Premission] WHERE Name = 'Conf. Doctos');
INSERT INTO [Premission] VALUES('Documentos','',null,'Documento','Index',null,@IdDocto,'Documento.png',1,0, 1);
INSERT INTO [Premission] VALUES('Campos','',null,'Campo','Index',null,@IdDocto,'Campos.png',1,1, 1);

INSERT INTO [Premission] VALUES('Materia Prima','',null,'MateriaPrima','Index',null,@IdMovimiento,'MateriaPrima.png',1,2, 1);
INSERT INTO [Premission] VALUES('Producto','',null,'Producto','Index',null,@IdMovimiento,'Producto.png',1,3, 1);
INSERT INTO [Premission] VALUES('Formula','',null,'Formula','Index',null,@IdMovimiento,'Formula.png',0,0, 1);

INSERT INTO [Premission] VALUES('Transacciones','',null,'Transaccion','Index',null,0,'Transaccion.png',1,3, 1);
SET @IdTransaccion = (SELECT Id FROM [Premission] WHERE Name = 'Transacciones');
INSERT INTO [Premission] VALUES('Ajustes','',null,null,null,null,@IdTransaccion,'Adjustment.png',0,0, 0);

INSERT INTO [Premission] VALUES('Reportes','',null,null,null,null,0,'Reportes.png',1,2, 0);
SET @IdReportes = (SELECT Id FROM [Premission] WHERE Name = 'Reportes');
INSERT INTO [Premission] VALUES('Declaraciones','',null,null,null,null,@IdReportes,'Reportes.png',1,0, 0);
INSERT INTO [Premission] VALUES('Detalles','',null,null,null,null,@IdReportes,'Reportes.png',1,1, 0);
INSERT INTO [Premission] VALUES('Listados','',null,null,null,null,@IdReportes,'Reportes.png',1,2, 0);
DECLARE @RptDeclaraciones	INT,
		@RptDetalles		INT,
		@RptListados		INT;
SET @RptDeclaraciones = (SELECT Id FROM [Premission] WHERE Name = 'Declaraciones');
SET @RptDetalles = (SELECT Id FROM [Premission] WHERE Name = 'Detalles');
SET @RptListados = (SELECT Id FROM [Premission] WHERE Name = 'Listados');
INSERT INTO [Premission] VALUES('Declaración Jurada','',null,'Reportes','DeclaracionJuradaUno',null,@RptDeclaraciones,'Reportes.png',1,0, 1);
INSERT INTO [Premission] VALUES('Declaración Jurada Gerencial','',null,'Reportes','DeclaracionJuradaGerencial',null,@RptDeclaraciones,'Reportes.png',1,0, 1);
INSERT INTO [Premission] VALUES('Declaración Jurada IVA separado','',null,'Reportes','DeclaracionJuradaDos',null,@RptDeclaraciones,'Reportes.png',1,0, 1);
INSERT INTO [Premission] VALUES('Detalle de descargo','',null,'Reportes','DetalleDescargo',null,@RptDetalles,'Reportes.png',2,0, 1);
INSERT INTO [Premission] VALUES('Detalle exportacion','',null,'Reportes','DetalleExportacion',null,@RptDetalles,'Reportes.png',2,0, 1);
INSERT INTO [Premission] VALUES('Lista Importacion','',null,'Reportes','ListaImportacion',null,@RptListados,'Reportes.png',2,0, 1);
INSERT INTO [Premission] VALUES('Lista Exportacion','',null,'Reportes','ListaExportacion',null,@RptListados,'Reportes.png',2,0, 1);
INSERT INTO [Premission] VALUES('Fichas Técnicas','',null,'Reportes','Formulas',null,@IdReportes,'Reportes.png',2,0, 4);

INSERT INTO [Premission] VALUES('Transmitir Opa','',null,'Transmision','Index',null,0,'Transmition.png',1,3, 1);
-------------------------------------------------------------------INSERTANDO MENU-------------------------------------------------------------------

------------------------------------------------------------------------PAISES-----------------------------------------------------------------------
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('AFGANISTAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ALBANIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ARGELIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SAMOA OCCIDENTAL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ANDORRA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ANGOLA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ANGUILLA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ANTARTIDA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ANTIGUA Y BARBUDA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ARGENTINA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ARMENIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ARUBA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('AUSTRALIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('AUSTRIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('AZERBAIYAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BAHAMAS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BAHREIN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BANGLADESH', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BARBADOS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BIELORRUSIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BELGICA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BELICE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BENIN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BERMUDAS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BHUTAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BOLIVIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BOSNIA Y HERZEGOVINA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BOTSWANA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLA BOUVET', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BRASIL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TERRITORIOS BRITANICOS DEL OCEANO INDICO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BRUNEI', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BULGARIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BURKINA FASO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BURUNDI', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CAMBOYA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CAMERUN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CANADA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CABO VERDE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS CAIMAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('REPUBLICA CENTROAFRICANA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CHAD', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CHILE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CHINA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLA DE CHRISTMAS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS DE COCOS O KEELING', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('COLOMBIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('COMORES', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CONGO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS COOK', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('COSTA RICA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('COSTA DEL MARFIL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CROACIA (HRVATSKA)', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CUBA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CHIPRE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('REPUBLICA CHECA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('DINAMARCA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('DJIBOURI', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('DOMINICA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('REPUBLICA DOMINICANA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TIMOR ORIENTAL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ECUADOR', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('EGIPTO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('EL SALVADOR', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GUINEA ECUATORIAL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ERITREA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ESTONIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ETIOPIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS MALVINAS (ISLAS FALKLAND)', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS FAROE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS FIYI', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('FINLANDIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('FRANCIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('FRANCIA METROPOLITANA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GUAYANA FRANCESA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('POLINESIA FRANCESA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TERRITORIOS FRANCESES DEL SUR', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GABON', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GAMBIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GEORGIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ALEMANIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GHANA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GIBRALTAR', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GRECIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GROENLANDIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GRANADA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GUADALUPE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GUAM', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GUATEMALA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GUINEA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GUINEA-BISSAU', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GUAYANA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('HAITI', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLA HEARD E ISLAS MCDONALD', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('HONDURAS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('HONG KONG R. A. E', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('HUNGRIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLANDIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('INDIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('INDONESIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('IRAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('IRAK', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('IRLANDA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISRAEL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ITALIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('JAMAICA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('JAPON', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('JORDANIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('KAZAJISTAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('KENIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('KIRIBATI', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('COREA DEL NORTE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('COREA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('KUWAIT', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('KIRGUIZISTAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('LAOS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('LETONIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('LIBANO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('LESOTHO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('LIBERIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('LIBIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('LIECHTENSTEIN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('LITUANIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('LUXEMBURGO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MACAO R. A. E', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('EX-REPUBLICA YUGOSLAVA DE MACEDONIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MADAGASCAR', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MALAWI', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MALASIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MALDIVAS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MALI', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MALTA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS MARSHALL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MARTINICA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MAURITANIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MAURICIO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MAYOTTE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MEXICO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MICRONESIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MOLDAVIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MONACO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MONGOLIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MONTSERRAT', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MARRUECOS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('MOZAMBIQUE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('BIRMANIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NAMIBIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NAURU', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NEPAL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('HOLANDA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ANTILLAS HOLANDESAS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NUEVA CALEDONIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NUEVA ZELANDA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NICARAGUA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NIGER', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NIGERIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NIUE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NORFOLK', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS MARIANAS DEL NORTE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('NORUEGA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('OMAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('PAQUISTAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS PALAU', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('PANAMA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('PAPUA NUEVA GUINEA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('PARAGUAY', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('PERU', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('FILIPINAS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('PITCAIRN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('POLONIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('PORTUGAL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('PUERTO RICO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('QATAR', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('REUNION', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('RUMANIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('RUSIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('RUANDA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SAN KITTS Y NEVIS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SANTA LUCIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SAN VICENTE E ISLAS GRANADINAS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SAMOA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SAN MARINO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SANTO TOME Y PRINCIPE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ARABIA SAUDI', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SENEGAL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SEYCHELLES', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SIERRA LEONA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SINGAPUR', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ESLOVAQUIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ESLOVENIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS SALOMON', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SOMALIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('REPUBLICA DE SUDAFRICA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GEORGIA DEL SUR Y LAS ISLAS SANDWICH DEL SUR', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ESPAñA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SRI LANKA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SANTA HELENA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SAN PIERRE Y MIQUELON', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SUDAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SURINAM', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SVALBARD', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SUAZILANDIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SUECIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SUIZA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SIRIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TAIWAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TAYIKISTAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TANZANIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TAILANDIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TOGO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS TOKELAU', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TONGA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TRINIDAD Y TOBAGO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TUNEZ', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TURQUIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TURKMENISTAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS TURKS Y CAICOS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('TUVALU', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('UGANDA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('UCRANIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('EMIRATOS ARABES UNIDOS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('GRAN BRETAÑA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ESTADOS UNIDOS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS MENORES DE ESTADOS UNIDOS', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('URUGUAY', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('UZBEKISTAN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('VANUATU', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('CIUDAD ESTADO DEL VATICANO (SANTA SEDE)', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('VENEZUELA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('VIETNAM', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS VIRGENES (REINO UNIDO)', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ISLAS VIRGENES (EE.UU.)', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('WALLIS Y FUTUNA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SAHARA DEL ESTE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('YEMEN', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('YUGOSLAVIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ZAIRE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ZAMBIA', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ZIMBABWE', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('REINO UNIDO (United Kingdom)', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('REPUBLICA DEMOCRATICA DEL CONGO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('ZONA NEUTRAL', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('SERBIA Y MONTENEGRO', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Country](Name, IdParent, RegisterDate, RegisterUser) VALUES('UNION EUROPEA', 0, GETDATE(), 'SYS_USER');
------------------------------------------------------------------------PAISES-----------------------------------------------------------------------

-----------------------------------------------------------------------MONEDAS-----------------------------------------------------------------------
INSERT INTO [Currency](IdCountry, Name, [Description], Symbol, ExchangeRate, RegisterDate, RegisterUser)
			VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'Quetzal', 'Quetzal', 'Q', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Currency](IdCountry, Name, [Description], Symbol, ExchangeRate, RegisterDate, RegisterUser)
			VALUES((select Id from [Country] where lower(name) = 'el salvador'), 'Dolar', 'Dolar', '$', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Currency](IdCountry, Name, [Description], Symbol, ExchangeRate, RegisterDate, RegisterUser)
			VALUES((select Id from [Country] where lower(name) = 'alemania'), 'Euro', 'Euro', '€', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Currency](IdCountry, Name, [Description], Symbol, ExchangeRate, RegisterDate, RegisterUser)
			VALUES((select Id from [Country] where lower(name) = 'honduras'), 'Lempira', 'Lempira', 'L', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Currency](IdCountry, Name, [Description], Symbol, ExchangeRate, RegisterDate, RegisterUser)
			VALUES((select Id from [Country] where lower(name) = 'nicaragua'), 'Córdova', 'Córdova', 'C$', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Currency](IdCountry, Name, [Description], Symbol, ExchangeRate, RegisterDate, RegisterUser)
			VALUES((select Id from [Country] where lower(name) = 'costa rica'), 'Colón', 'Colón', '₡', 0, GETDATE(), 'SYS_USER');
INSERT INTO [Currency](IdCountry, Name, [Description], Symbol, ExchangeRate, RegisterDate, RegisterUser)
			VALUES((select Id from [Country] where lower(name) = 'panama'), 'Balboa', 'Balboa', 'B/', 0, GETDATE(), 'SYS_USER');
-----------------------------------------------------------------------MONEDAS-----------------------------------------------------------------------

-----------------------------------------------------------------------ADUANAS-----------------------------------------------------------------------
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'SAN CRISTOBAL', 'GTAMI', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'CHAMPERICO', 'GTCHR', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'EL FLORIDO', 'GTCIQ', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'AGUA CALIENTE', 'GTCIQ', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'LA ERMITA', 'GTCIQ', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'TECUN UMAN', 'GTCTU', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'SANTA ELENA', 'GTFRS', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'DE VEHICULOS', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'CENTRAL DE GUATEMALA', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'CENTRAL DE AVIACION', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'EXPRESS AEREO', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'FARDOS POSTALES', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'ALMACENADORA INTEGRADA', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'ALMINTER', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'ALPASA', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'ALSERSA', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'CEALSA', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'ALMAGUATE', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'ALCORSA', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'CENTRALSA', 'GTGUA', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'LA MESILLA', 'GTHUG', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'PEDRO DE ALVARADO', 'GTJUT', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'VALLE NUEVO', 'GTJUT', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'MELCHOR DE MENCOS', 'GTMCR', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'PUERTO BARRIOS', 'GTPBR', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'PUERTO QUETZAL', 'GTPRQ', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'EL CARMEN', 'GTSMM', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'guatemala'), 'SANTO TOMAS DE CASTILLA', 'GTSTC', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'honduras'), 'PUERTO CORTES', 'HNPCR', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'nicaragua'), 'PUERTO CORINTO', 'NICIO', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'nicaragua'), 'PEÑAS BLANCAS', 'NIRVV', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'el salvador'), 'PUERTO ACAJUTLA', 'SVAQJ', GETDATE(), 'SYS_USER');
INSERT INTO [Customs](IdCountry, Name, [Address], RegisterDate, RegisterUser) VALUES((select Id from [Country] where lower(name) = 'el salvador'), 'PUERTO DE COTUCO', 'SVLUN', GETDATE(), 'SYS_USER');
-----------------------------------------------------------------------ADUANAS-----------------------------------------------------------------------

------------------------------------------------------------------UNIDAD DE MEDIDA-------------------------------------------------------------------
INSERT INTO [UnitMeasurement](Name, [Description], Symbol, RegisterDate, RegisterUser)
			VALUES('Arroba', 'Arroba', '@@', GETDATE(), 'SYS_USER');
INSERT INTO [UnitMeasurement](Name, [Description], Symbol, RegisterDate, RegisterUser)
			VALUES('Litros', 'Litros', 'lts', GETDATE(), 'SYS_USER');
INSERT INTO [UnitMeasurement](Name, [Description], Symbol, RegisterDate, RegisterUser)
			VALUES('Mililitros', 'Mililitros', 'ml', GETDATE(), 'SYS_USER');
INSERT INTO [UnitMeasurement](Name, [Description], Symbol, RegisterDate, RegisterUser)
			VALUES('Libra', 'Libra', 'lb', GETDATE(), 'SYS_USER');
INSERT INTO [UnitMeasurement](Name, [Description], Symbol, RegisterDate, RegisterUser)
			VALUES('Onzas', 'Onzas', 'oz', GETDATE(), 'SYS_USER');
INSERT INTO [UnitMeasurement](Name, [Description], Symbol, RegisterDate, RegisterUser)
			VALUES('Gramos', 'Gramos', 'g', GETDATE(), 'SYS_USER');
INSERT INTO [UnitMeasurement](Name, [Description], Symbol, RegisterDate, RegisterUser)
			VALUES('Miligramos', 'Miligramos', 'mg', GETDATE(), 'SYS_USER');
INSERT INTO [UnitMeasurement](Name, [Description], Symbol, RegisterDate, RegisterUser)
			VALUES('Metros', 'Metros', 'm', GETDATE(), 'SYS_USER');
INSERT INTO [UnitMeasurement](Name, [Description], Symbol, RegisterDate, RegisterUser)
			VALUES('Centimetros', 'Centimetros', 'cm', GETDATE(), 'SYS_USER');
------------------------------------------------------------------UNIDAD DE MEDIDA-------------------------------------------------------------------

------------------------------------------------------------------TIPOS DE TELEFONO------------------------------------------------------------------
insert into PhoneType values('Celular');
insert into PhoneType values('Casa');
insert into PhoneType values('Trabajo');
------------------------------------------------------------------TIPOS DE TELEFONO------------------------------------------------------------------

-------------------------------------------------------------------TIPOS DE EMAIL--------------------------------------------------------------------
insert into EmailType values('Personal');
insert into EmailType values('Trabajo');
insert into EmailType values('Negocio');
-------------------------------------------------------------------TIPOS DE EMAIL--------------------------------------------------------------------

------------------------------------------------------------------TIPOS DE DIRECCIÓN-----------------------------------------------------------------
INSERT INTO [AddressType] VALUES('Domicilio');
INSERT INTO [AddressType] VALUES('Negocio');
INSERT INTO [AddressType] VALUES('Trabajo');
------------------------------------------------------------------TIPOS DE DIRECCIÓN-----------------------------------------------------------------

-----------------------------------------------------------------------CUENTAS-----------------------------------------------------------------------
INSERT INTO [Account] (Name, [Description], RegisterDate, RegisterUser)
			VALUES ('Cta cte 2989', 'Cta cte 2989', GETDATE(), 'SYS_USER');
INSERT INTO [Account] (Name, [Description], RegisterDate, RegisterUser)
			VALUES ('Constancias', 'Constancias', GETDATE(), 'SYS_USER');
-----------------------------------------------------------------------CUENTAS-----------------------------------------------------------------------

----------------------------------------------------------------ESTADOS DE DOCUMENTO-----------------------------------------------------------------
INSERT INTO [State] VALUES('Ingresado');
INSERT INTO [State] VALUES('Grabado');
INSERT INTO [State] VALUES('Revisado');
----------------------------------------------------------------ESTADOS DE DOCUMENTO-----------------------------------------------------------------

-------------------------------------------------------------------ESTADOS DE OPA--------------------------------------------------------------------
INSERT INTO [State] VALUES('Cola');
INSERT INTO [State] VALUES('Procesando');
INSERT INTO [State] VALUES('Espera');
INSERT INTO [State] VALUES('Validando');
INSERT INTO [State] VALUES('Valido');
INSERT INTO [State] VALUES('Transmitiendo');
INSERT INTO [State] VALUES('Transmitido');
INSERT INTO [State] VALUES('Finalizado');
INSERT INTO [State] VALUES('Error Transmisión');
-------------------------------------------------------------------ESTADOS DE OPA--------------------------------------------------------------------

---------------------------------------------------------------------PRIORIDADES---------------------------------------------------------------------
INSERT INTO [Priority] VALUES('Alta', 1);
INSERT INTO [Priority] VALUES('Media', 2);
INSERT INTO [Priority] VALUES('Baja', 3);
---------------------------------------------------------------------PRIORIDADES---------------------------------------------------------------------

----------------------------------------------------------------------PARAMETROS----------------------------------------------------------------------
DECLARE	@IdDefualtCurrency	INT

SELECT @IdDefualtCurrency = Id FROM [Currency] WHERE [Name] = 'Dolar';

INSERT INTO [Parameters](IVA, ExpirateDateMonts, DefaultCurrency, OpaFrecuencySeconds, OpaDelaySeconds, OpaServiceUrl, OpaServiceUser,
						OpaServicePassword, DaysToExpire, MailingUser, MailingPassword, MailingServer, MailingPort, MailingUseSsl, 
						MailingDisplayName, MailingIsHtml, OpaEmailBody, MailingCC, MailingCCO) 
VALUES(0.12, 12, @IdDefualtCurrency, 10, 6, 'https://sws.export.com.gt/Desa/WS_OPA_2015/WSOPA.asmx', 'uIndex', 'Index0707Ws', 30,
		'opatestermail@gmail.com', 'prueba123$$', 'smtp.gmail.com', 587, 1, 'Index Aduana App', 1, 
		'C:\TFS\Index Aduana\RELEASES\Release 2.0.0.0\SOURCE CODE\Index.Aduana\Index.Web\EmailFormats\EmailFormat.html', null, 
		'gabriel.rangel@rymtech.com.gt');
----------------------------------------------------------------------PARAMETROS----------------------------------------------------------------------

-------------------------------------------------------------------CAMPOS DINAMICOS-------------------------------------------------------------------
INSERT INTO [Table](Name) VALUES ('FileHeader');
INSERT INTO [Table](Name) VALUES ('FileDetail');
INSERT INTO [Table](Name) VALUES ('FileAttached');

DECLARE @IdDetail	INT,
		@IdHeader	INT,
		@IdAttached	INT;

SELECT	@IdHeader = Id
  FROM	[Table]
 WHERE	Name = 'FileHeader';
	
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Número de documento','IdDocument', 'TextBox', 1);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Fecha de autorización','AuthorizationDate', 'DatePicker', 1);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Fecha de ampliación','ExpantionDate', 'DatePicker', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Fecha de expiración','ExpirationDate', 'DatePicker', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Fecha del documento','DocumentDate', 'DatePicker', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Tasa de cambio','ExchangeRate', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Seguro','Insurance', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Flete','Cargo', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'País','IdCountry', 'DropDownList', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Aduana','IdCustom', 'DropDownList', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Garantia','IdWarranty', 'DropDownList', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Moneda','IdCurrency', 'DropDownList', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Resolucion','IdResolution', 'DropDownList', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdHeader, 'Bodega','IdCellar', 'DropDownList', 0);
insert into [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) values (@IdHeader, 'Fecha Llegada', 'ArrivalDAte', 'DatePicker', 0)
insert into [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) values (@IdHeader, 'Total CIF', 'CIFTotal', 'NumericTextBox', 0)
insert into [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) values (@IdHeader, 'Total Lineas', 'LinesTotal', 'NumericTextBox', 0)


SELECT	@IdDetail = Id
  FROM	[Table]
 WHERE	Name = 'FileDetail';
 
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'No. Linea','TransactionLine', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'Cantidad artículo','ItemQuantity', 'NumericTextBox', 1);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'Artículo','IdItem', 'DropDownList', 1);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'Costo CIF Quetzales','CIFcostQuetzal', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'Costo FO Quetzales','FOcostQuetzal', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'Costo CIF Dolares','CIFcostDollar', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'Costo FO Dolares','FOcostDollar', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'Aranceles','CustomDuties', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'IVA','Iva', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'Base Imponible','TaxableBase', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdDetail, 'Tasa Impositiva','TaxRate', 'NumericTextBox', 0);
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) values (@IdDetail, 'Peso Neto', 'NetWeight', 'NumericTextBox', 0)
INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) values (@IdDetail, 'Peso Bruto', 'GrossWeight', 'NumericTextBox', 0)

SELECT	@IdAttached = Id
  FROM	[Table]
 WHERE	Name = 'FileAttached';
 
 INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdAttached, 'Proveedor','IdSupplier', 'DropDownList', 1);
 INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdAttached, 'Nombre del adjunto','Description', 'TextBox', 0);
 INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdAttached, 'Número del adjunto','AttachedNumber', 'TextBox', 1);
 INSERT INTO [Fields](IdTable, Name, DataBaseName, HtmlObject, IsRequired) VALUES (@IdAttached, 'Fecha del adjunto','AttachedDate', 'DatePicker', 1);
-------------------------------------------------------------------CAMPOS DINAMICOS-------------------------------------------------------------------

-------------------------------------------------------------------TIPO DE DOCUMENTO------------------------------------------------------------------
INSERT INTO [FileInfoType]([Name], [Description]) VALUES('Importación',NULL);
INSERT INTO [FileInfoType]([Name], [Description]) VALUES('Exportación',NULL);
INSERT INTO [FileInfoType]([Name], [Description]) VALUES('Resolución',NULL);
-------------------------------------------------------------------TIPO DE DOCUMENTO------------------------------------------------------------------

-----------------------------------------------------------------------DOCUMENTO----------------------------------------------------------------------
EXEC spi_FileInfo 'DUA', NULL, 'SYS_USER';
EXEC spi_FileInfo 'FAUCA', NULL, 'SYS_USER';
EXEC spi_FileInfo 'Nacionalización', NULL, 'SYS_USER';
EXEC spi_FileInfo 'Acta Destrucción', NULL, 'SYS_USER';
EXEC spi_FileInfo 'Póliza', NULL, 'SYS_USER';
EXEC spi_FileInfo 'Factura', NULL, 'SYS_USER';
-----------------------------------------------------------------------DOCUMENTO----------------------------------------------------------------------

----------------------------------------------------------------CONFIGURACION DOCUMENTO---------------------------------------------------------------
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

EXEC spi_FileInfoConfig @DUA, @Import, @Account2989, 1, 0, 1, 0, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @DUA, @Export, @Account2989, 1, 1, 1, 1, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @FAUCA, @Export, @Account2989, 1, 1, 1, 1, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @NAC, @Export, @Account2989, 1, 1, 1, 0, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @DESTC, @Export, @Account2989, 1, 1, 1, 0, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @POLIZA, @Import, @Account2989, 1, 0, 1, 0, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @POLIZA, @Export, @Account2989, 1, 1, 1, 1, 1, 'SYS_USER'

EXEC spi_FileInfoConfig @DUA, @Export, @AccountCONST, 0, 1, 1, 0, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @FAUCA, @Export, @AccountCONST, 0, 1, 1, 0, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @FACT, @Import, @AccountCONST, 0, 0, 1, 0, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @NAC, @Export, @AccountCONST, 0, 1, 1, 0, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @DESTC, @Export, @AccountCONST, 0, 1, 1, 0, 1, 'SYS_USER'
EXEC spi_FileInfoConfig @POLIZA, @Export, @AccountCONST, 0, 1, 1, 0, 1, 'SYS_USER'
 ----------------------------------------------------------------CONFIGURACION DOCUMENTO---------------------------------------------------------------

 -------------------------------------------------------------------------CAMPOS-----------------------------------------------------------------------
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
		 @DestcExport_const		INT,
		 @PolizaImport_2989		INT,
		 @PolizaExport_2989		INT,
		 @PolizaExport_const	INT;
		 
SELECT @DuaImport_2989 = Id FROM [FileInfoConfig] WHERE IdAccount = @2989 AND IdFileInfo = @DUA AND IdFileType  = @Import;
SELECT @DuaExport_2989 = Id FROM [FileInfoConfig] WHERE IdAccount = @2989 AND IdFileInfo = @DUA AND IdFileType  = @Export;
--SELECT @FactImport_2989 = Id FROM [FileInfoConfig] WHERE IdAccount = @2989 AND IdFileInfo = @FACT AND IdFileType  = @Import;
SELECT @FaucaExport_2989 = Id FROM [FileInfoConfig] WHERE IdAccount = @2989 AND IdFileInfo = @FAUCA AND IdFileType  = @Export;
SELECT @NacExport_2989 = Id FROM [FileInfoConfig] WHERE IdAccount = @2989 AND IdFileInfo = @NAC AND IdFileType  = @Export;
SELECT @DestcExport_2989 = Id FROM [FileInfoConfig] WHERE IdAccount = @2989 AND IdFileInfo = @DESTC AND IdFileType  = @Export;
SELECT @PolizaImport_2989 = Id FROM [FileInfoConfig] WHERE IdAccount = @2989 AND IdFileInfo = @POLIZA AND IdFileType  = @Import;
SELECT @PolizaExport_2989 = Id FROM [FileInfoConfig] WHERE IdAccount = @2989 AND IdFileInfo = @POLIZA AND IdFileType  = @Export;

--SELECT @DuaImport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @DUA AND IdFileType  = @Import;
SELECT @DuaExport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @DUA AND IdFileType  = @Export;
SELECT @FactImport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @FACT AND IdFileType  = @Import;
SELECT @FaucaExport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @FAUCA AND IdFileType  = @Export;
SELECT @NacExport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @NAC AND IdFileType  = @Export;
SELECT @DestcExport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @DESTC AND IdFileType  = @Export;
SELECT @PolizaExport_const = Id FROM [FileInfoConfig] WHERE IdAccount = @Constancia AND IdFileInfo = @POLIZA AND IdFileType  = @Export;

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

EXEC spi_FileMasterDisplay @DuaImport_2989, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaImport_2989, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaImport_2989, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaImport_2989, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaImport_2989, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaImport_2989, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaImport_2989, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaImport_2989, @IdWarranty, 'Tipo Garantía', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaImport_2989, @Insurance, 'Seguro', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaImport_2989, @Cargo, 'Flete', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @PolizaImport_2989, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaImport_2989, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaImport_2989, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaImport_2989, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaImport_2989, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaImport_2989, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaImport_2989, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaImport_2989, @IdWarranty, 'Tipo Garantía', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaImport_2989, @Insurance, 'Seguro', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaImport_2989, @Cargo, 'Flete', 1, 1, 'SYS_USER'

--EXEC spi_FileMasterDisplay @DuaImport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @DuaImport_const, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @DuaImport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @DuaImport_const, @IdCountry, 'País', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @DuaImport_const, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @DuaImport_const, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @DuaImport_const, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @DuaImport_const, @IdWarranty, 'Tipo Garantía', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @DuaImport_const, @Insurance, 'Seguro', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @DuaImport_const, @Cargo, 'Flete', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @DuaExport_2989, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_2989, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_2989, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_2989, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_2989, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_2989, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_2989, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER' 

EXEC spi_FileMasterDisplay @DuaExport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DuaExport_const, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @PolizaExport_2989, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_2989, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_2989, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_2989, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_2989, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_2989, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_2989, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER' 

EXEC spi_FileMasterDisplay @PolizaExport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_const, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_const, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_const, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_const, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @PolizaExport_const, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @FaucaExport_2989, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_2989, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_2989, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_2989, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_2989, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_2989, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_2989, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @FaucaExport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FaucaExport_const, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER'

--EXEC spi_FileMasterDisplay @FactImport_2989, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @FactImport_2989, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @FactImport_2989, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @FactImport_2989, @IdCountry, 'País', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @FactImport_2989, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @FactImport_2989, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
--EXEC spi_FileMasterDisplay @FactImport_2989, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @FactImport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @IdCustom, 'Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @IdCountry, 'País', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @ExchangeRate, 'Tipo Cambio', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @CifTotal, 'Total Val. Aduana', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @FactImport_const, @LinesTotal, 'Total Lineas', 1, 1, 'SYS_USER' 

EXEC spi_FileMasterDisplay @NacExport_2989, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @NacExport_2989, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @NacExport_const, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @NacExport_const, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'

EXEC spi_FileMasterDisplay @DestcExport_2989, @IdDocument, 'No. Orden', 1, 1, 'SYS_USER'
EXEC spi_FileMasterDisplay @DestcExport_2989, @AutorizationDate, 'Fec. Aceptación', 1, 1, 'SYS_USER'

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

EXEC spi_FileDetailDisplay @DuaImport_2989, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @CIFcostQuetzal, 'CIF Q', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @FOcostQuetzal, 'FOB Q', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @CIFcostDollar, 'CIF $', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @FOcostDollar, 'FOB $', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @CustomDuties, 'DAI', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @Iva, 'IVA', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @TaxableBase, 'Base Imponible', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @TaxRate, 'Tasa Impositiva', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @NetWeight, 'Peso Neto', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaImport_2989, @GrossWeight, 'Peso Bruto', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @PolizaImport_2989, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @CIFcostQuetzal, 'CIF Q', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @FOcostQuetzal, 'FOB Q', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @CIFcostDollar, 'CIF $', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @FOcostDollar, 'FOB $', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @CustomDuties, 'DAI', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @Iva, 'IVA', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @TaxableBase, 'Base Imponible', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @TaxRate, 'Tasa Impositiva', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @NetWeight, 'Peso Neto', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaImport_2989, @GrossWeight, 'Peso Bruto', 1, 1, 'SYS_USER'

--EXEC spi_FileDetailDisplay @DuaImport_const, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @CIFcostQuetzal, 'CIF Q', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @FOcostQuetzal, 'FOB Q', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @CIFcostDollar, 'CIF $', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @FOcostDollar, 'FOB $', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @CustomDuties, 'DAI', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @Iva, 'IVA', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @TaxableBase, 'Base Imponible', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @TaxRate, 'Tasa Impositiva', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @NetWeight, 'Peso Neto', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @DuaImport_const, @GrossWeight, 'Peso Bruto', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @NacExport_2989, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @CIFcostQuetzal, 'CIF Q', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @FOcostQuetzal, 'FOB Q', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @CIFcostDollar, 'CIF $', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @FOcostDollar, 'FOB $', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @CustomDuties, 'DAI', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @Iva, 'IVA', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @TaxableBase, 'Base Imponible', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @TaxRate, 'Tasa Impositiva', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @NetWeight, 'Peso Neto', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @NacExport_2989, @GrossWeight, 'Peso Bruto', 1, 1, 'SYS_USER'

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

EXEC spi_FileDetailDisplay @DuaExport_2989, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaExport_2989, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaExport_2989, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @DuaExport_const, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaExport_const, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DuaExport_const, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @PolizaExport_2989, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaExport_2989, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaExport_2989, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @PolizaExport_const, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaExport_const, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @PolizaExport_const, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @FaucaExport_2989, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @FaucaExport_2989, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @FaucaExport_2989, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @FaucaExport_const, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @FaucaExport_const, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @FaucaExport_const, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

--EXEC spi_FileDetailDisplay @FactImport_2989, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @FactImport_2989, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
--EXEC spi_FileDetailDisplay @FactImport_2989, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @FactImport_const, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @FactImport_const, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @FactImport_const, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

EXEC spi_FileDetailDisplay @DestcExport_2989, @TransactionLine, 'No. Línea', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DestcExport_2989, @IdItem, 'Código SAC', 1, 1, 'SYS_USER'
EXEC spi_FileDetailDisplay @DestcExport_2989, @ItemQuantity, 'Cantidad', 1, 1, 'SYS_USER'

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

EXEC spi_FileAttachedDisplay @DuaImport_2989, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @DuaImport_2989, @Description, 'Descripción', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @DuaImport_2989, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @DuaImport_2989, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

EXEC spi_FileAttachedDisplay @PolizaImport_2989, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @PolizaImport_2989, @Description, 'Descripción', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @PolizaImport_2989, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @PolizaImport_2989, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

--EXEC spi_FileAttachedDisplay @DuaImport_const, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @DuaImport_const, @Description, 'Descripción', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @DuaImport_const, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @DuaImport_const, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

EXEC spi_FileAttachedDisplay @NacExport_2989, @IdSupplier, 'Cliente', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @NacExport_2989, @Description, 'Descripción', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @NacExport_2989, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @NacExport_2989, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

--EXEC spi_FileAttachedDisplay @NacExport_const, @IdSupplier, 'Cliente', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @NacExport_const, @Description, 'Descripción', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @NacExport_const, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @NacExport_const, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

EXEC spi_FileAttachedDisplay @DuaExport_2989, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @DuaExport_2989, @Description, 'Descripción', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @DuaExport_2989, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @DuaExport_2989, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

EXEC spi_FileAttachedDisplay @PolizaExport_2989, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @PolizaExport_2989, @Description, 'Descripción', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @PolizaExport_2989, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @PolizaExport_2989, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

--EXEC spi_FileAttachedDisplay @DuaExport_const, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @DuaExport_const, @Description, 'Descripción', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @DuaExport_const, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @DuaExport_const, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

EXEC spi_FileAttachedDisplay @FaucaExport_2989, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @FaucaExport_2989, @Description, 'Descripción', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @FaucaExport_2989, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @FaucaExport_2989, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

--EXEC spi_FileAttachedDisplay @FaucaExport_const, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @FaucaExport_const, @Description, 'Descripción', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @FaucaExport_const, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @FaucaExport_const, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

--EXEC spi_FileAttachedDisplay @FactImport_2989, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @FactImport_2989, @Description, 'Descripción', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @FactImport_2989, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @FactImport_2989, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

--EXEC spi_FileAttachedDisplay @FactImport_const, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @FactImport_const, @Description, 'Descripción', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @FactImport_const, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @FactImport_const, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

EXEC spi_FileAttachedDisplay @DestcExport_2989, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @DestcExport_2989, @Description, 'Descripción', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @DestcExport_2989, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
EXEC spi_FileAttachedDisplay @DestcExport_2989, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'

--EXEC spi_FileAttachedDisplay @DestcExport_const, @IdSupplier, 'Proveedor', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @DestcExport_const, @Description, 'Descripción', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @DestcExport_const, @AttachedNumber, 'No. Documento', 1, 1, 'SYS_USER'
--EXEC spi_FileAttachedDisplay @DestcExport_const, @AttachedDate, 'Fecha Documento', 1, 1, 'SYS_USER'
-------------------------------------------------------------------------CAMPOS-----------------------------------------------------------------------
