CREATE TABLE [dbo].[tbl_mgr_proveedor]
(
	id_proveedor	INT NOT NULL,
	id_person		INT NULL,
	Nit				varchar(25) NULL,
	Nombre			VARCHAR(500) NOT NULL,
	Direccion		VARCHAR(1000) NOT NULL,
	Local_Externo	BIT null,
	id_error		INT NULL,
	fecha_proceso	DATETIME,
	PRIMARY KEY(id_proveedor)
)