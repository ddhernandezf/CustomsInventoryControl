CREATE TABLE [dbo].[tbl_mgr_transmision_log]
(
	Id_Log_Transmision	INT NOT NULL,
	IdOpaDetail			INT NULL,
	Id_Transmision		INT NOT NULL,
	IdOpaHeader			INT	NULL,
	Id_Relacion_Detalle INT NOT NULL,
	IdFileItemDischarge	INT NULL,
	Fecha_Carga			datetime NOT NULL,
	Codigo_Envio		varchar(20) NOT NULL,
	Fecha_Envio			datetime NULL,
	Tipo_Envio			varchar(1) NOT NULL,
	Tipo_Cuenta			varchar(2) NOT NULL,
	Exportador			int NOT NULL,
	Nit					varchar(30) NOT NULL,
	Poliza_Importacion	varchar(100) NOT NULL,
	Linea_Importacion	int NOT NULL,
	Cantidad			numeric(18, 6) NOT NULL,
	Cif					numeric(18, 6) NOT NULL,
	Dai					numeric(18, 6) NOT NULL,
	Iva					numeric(18, 6) NOT NULL,
	Poliza_Exportacion	varchar(100) NOT NULL,
	Linea_Exportacion	int NOT NULL,
	Tipo_Error			varchar(1) NOT NULL,
	Mensaje_Error		varchar(350) NULL,
	Numero_Operacion	int NULL,
	Cif_Opa				numeric(18, 6) NULL,
	Dai_Opa				numeric(18, 6) NULL,
	Iva_Opa				numeric(18, 6) NULL,
	Multa_Nacionalizacion varchar(200) NULL,
	Monto_Multa_Nacionalizacion numeric(18, 6) NULL,
	Multa_Extemporanea	varchar(200) NULL,
	Monto_Multa_Extemporanea numeric(18, 6) NULL,
	PRIMARY KEY(Id_Log_Transmision)
)
GO
CREATE INDEX inx_mgr_transaccion_log_pk ON tbl_mgr_transmision_log(Id_Log_Transmision)
GO
CREATE INDEX inx_mgr_transaccion_log_fk ON tbl_mgr_transmision_log(Id_Transmision)
GO
CREATE INDEX inx_mgr_transaccion_log_rd ON tbl_mgr_transmision_log(Id_Relacion_Detalle)
GO
