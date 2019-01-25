CREATE TABLE [dbo].[tbl_mgr_transaccion]
(
	Id_Transaccion	INT NOT NULL,
	Import_Export	BIT NOT NULL,
	Linea			INT NULL,
	IdFileDetail	INT NULL,
	Id_Documento	INT NULL,
	IdFileHeader	INT NULL,
	Id_MP			INT NULL,
	IdItem			INT NULL,
	Cantidad		Numeric(18,6) NULL,
	CIF_Q			Numeric(18,6) NULL,
	CIF_D			Numeric(18,6) NULL,
	FOB_Q			Numeric(18,6) NULL,
	FOB_D			Numeric(18,6) NULL,
	DAI				Numeric(18,6) NULL,
	IVA				Numeric(18,6) NULL,
	Fecha_Sistema	DATETIME NULL,
	id_error		INT NULL,
	fecha_proceso	DATETIME,
	PRIMARY KEY(Id_Transaccion,Import_Export)
)
GO

CREATE INDEX inx_mgr_transaccion_pk ON dbo.tbl_mgr_transaccion (Id_Transaccion)
GO

CREATE INDEX inx_mgr_transaccion ON tbl_mgr_transaccion(Import_Export,Id_Documento)
GO

CREATE INDEX inx_mgr_transaccion_fd ON tbl_mgr_transaccion(IdFileDetail)
GO

CREATE INDEX inx_mgr_transaccion_fh ON tbl_mgr_transaccion(IdFileHeader)
GO
