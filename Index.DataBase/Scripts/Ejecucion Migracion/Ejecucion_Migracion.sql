----------*****************  DATOS DE CATALAOGOS PARA LAS MIGRACION EJECUCION *********-----------------------------------------------------------------
--- Ejecucion y pruebas procedimiento carga de aduanas

Declare @Cant int;
exec dbo.sp_mgr_cargar_aduana @Cant output
--- Ejecucion y pruebas procedimiento carga de aduanas

--- Ejecucion y pruebas procedimiento carga de garantias

Declare @Cant int;
exec dbo.sp_mgr_cargar_garantia @Cant output
--- Ejecucion y pruebas procedimiento carga de garantias

--- Ejecucion y pruebas procedimiento carga de paises

Declare @Cant int;
exec dbo.sp_mgr_cargar_pais @Cant output
--- Ejecucion y pruebas procedimiento carga de paises

----------*****************  DATOS DE CATALAOGOS PARA LAS MIGRACION EJECUCION *********-----------------------------------------------------------------

--- Prueba de procedimiento para migrar clientes rutina para todos los clientes
	Declare @Cant int;
	exec dbo.sp_mgr_cargar_cliente @Cant output
--- Prueba de procedimiento para migrar clientes rutina para todos los clientes

--- Prueba de procedimiento para migrar proveedores rutina para todos los proveedores
	Declare @Cant int;
	exec dbo.sp_mgr_cargar_proveedor @Cant output
--- Prueba de procedimiento para migrar proveedores rutina para todos los proveedores

--- Ejecucion y pruebas procedimiento carga de unidades de medida

	Declare @Cant int;
	exec dbo.sp_mgr_cargar_UM @Cant output
--- Ejecucion y pruebas procedimiento carga de unidades de medida

--- Ejecucion y pruebas procedimiento carga de materias primas y productos

	Declare @Cant int;
	exec dbo.sp_mgr_cargar_MP @Cant output
--- Ejecucion y pruebas procedimiento carga de materias primas y productos

--- Ejecucion y pruebas procedimiento correccion de datos viejos para migrarlos a la base de datos nueva

	Declare @Cant int;
	exec dbo.sp_mgr_correccion_datos @Cant output
--- Ejecucion y pruebas procedimiento correccion de datos viejos para migrarlos a la base de datos nueva

--- Ejecucion y pruebas procedimiento carga de documentos

	Declare @Cant numeric(6,0);
	exec dbo.sp_mgr_cargar_documento @Cant output
--- Ejecucion y pruebas procedimiento carga de documentos

--- Ejecucion y pruebas procedimiento carga de transacciones

	Declare @Cant numeric(6,0);
	exec dbo.sp_mgr_cargar_transaccion @Cant output
--- Ejecucion y pruebas procedimiento carga de transacciones

--- Ejecucion y pruebas procedimiento carga de transacciones detalle o descargos

	Declare @Cant numeric(6,0);
	exec dbo.sp_mgr_cargar_detalle @Cant output
	--- Ejecucion y pruebas procedimiento carga de transacciones detalle o descargos

--- Ejecucion y pruebas procedimiento carga de cabeceras de transmision

	Declare @Cant numeric(6,0);
	exec dbo.sp_mgr_transmision @Cant output
--- Ejecucion y pruebas procedimiento carga de cabeceras de transmision

--- Ejecucion y pruebas procedimiento carga de log de transmisiones

	Declare @Cant numeric(6,0);
	exec dbo.sp_mgr_transmision_log @Cant output
--- Ejecucion y pruebas procedimiento carga de log de transmisiones