CREATE TABLE [dbo].[tbl_mgr_cliente]
(
	id_cliente			INT NOT NULL,
	id_person			INT NULL,
	id_Account			INT NULL,
	Nit					varchar(25) NULL,
	Nombre				VARCHAR(500) NOT NULL,
	Direccion			VARCHAR(1000) NOT NULL,
	Codigo_Cliente		varchar(100) NOT NULL,
	Codigo_Impor_Expor	varchar(100) NULL,
	id_error			INT NULL,
	constancia			BIT null,
	fecha_proceso		DATETIME,
	PRIMARY KEY(Id_cliente)
)
