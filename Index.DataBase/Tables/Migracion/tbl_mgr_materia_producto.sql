CREATE TABLE [dbo].[tbl_mgr_materia_producto]
(
	id_Materia_Producto INT NOT NULL,
	Producto			BIT not null,
	IdItem				INT NULL,
	id_Cliente			INT NULL,
	IdPerson			INT NULL,
	Descripcion			varchar(250) NULL,
	Codigo				VARCHAR(50) NULL,
	Codigo_barras		VARCHAR(50) NULL,
	Partida				VARCHAR(50) NULL,
	id_resolucion		INT null,
	id_unidad_medida	INT null,
	id_error			INT NULL,
	fecha_proceso		DATETIME,
	PRIMARY KEY(Id_materia_producto,Producto)
)