CREATE TABLE [dbo].[tbl_mgr_transaccion_detalle]
(
	Id_Detalle		INT NOT NULL,
	IdFileItemD		INT NULL,
	Id_Detalle_E	INT NULL,
	IdFileDSubst	INT NULL,
	Id_Detalle_I	INT NULL,
	IdFileDStock	INT NULL,
	Cantidad		Numeric(18,6) NULL,
	Cantidad_Merma	Numeric(18,6) NULL,
	CIF_Q			Numeric(18,6) NULL,
	FOB_Q			Numeric(18,6) NULL,
	DAI				Numeric(18,6) NULL,
	IVA				Numeric(18,6) NULL,
	Fecha_Sistema	DATETIME NULL,
	id_error		INT NULL,
	fecha_proceso	DATETIME,
	PRIMARY KEY(Id_Detalle)
)
GO

CREATE INDEX inx_mgr_transaccion_pk ON tbl_mgr_transaccion_detalle(Id_Detalle)
GO

CREATE INDEX inx_mgr_transaccion_exp ON tbl_mgr_transaccion_detalle(Id_Detalle_E)
GO

CREATE INDEX inx_mgr_transaccion_imp ON tbl_mgr_transaccion_detalle(Id_Detalle_I)
GO

CREATE INDEX inx_mgr_transaccion_fid ON tbl_mgr_transaccion_detalle(IdFileItemD)
GO
