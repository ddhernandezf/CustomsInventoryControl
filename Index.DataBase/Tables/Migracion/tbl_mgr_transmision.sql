CREATE TABLE [dbo].[tbl_mgr_transmision]
(
	Id_Transmision	INT NOT NULL,
	IdOpaHeader		INT NULL,
	Id_Usuario		INT NOT NULL,
	Id_Cliente		INT NOT NULL,
	IdCustomer		INT NULL,
	IdAccount		INT NULL,
	Fecha_Sistema	datetime NOT NULL,
	Fecha_Inicial	datetime NOT NULL,
	Fecha_Final		datetime NOT NULL,
	PRIMARY KEY(Id_Transmision)
)
GO
CREATE INDEX inx_mgr_transaccion_pk ON tbl_mgr_transmision(Id_Transmision)
GO