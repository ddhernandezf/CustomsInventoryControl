CREATE TABLE [dbo].[tbl_mgr_documento]
(
	Id_Documento		INT NOT NULL,
	Import_Export		BIT NOT NULL,
	IdFileHeader		INT NULL,
	id_Cliente			INT NULL,
	IdPerson			INT NULL,
	Id_Aduana			INT NULL,
	IdCustom			INT NULL,
	Id_Pais				INT NULL,
	IdCountry			INT NULL,
	Id_Proveedor		INT NULL,
	IdSupplier			INT NULL,
	Id_Garantia			INT NULL,
	IdWarranty			INT NULL,
	Id_Tipo_Documento	INT NULL,
	IdFileInfoConfig	INT NULL,
	Id_Moneda			INT NULL,
	IdCurrency			INT NULL,
	Tipo_Cambio			Numeric(18,6) NULL,
	Seguro				Numeric(18,6) NULL,
	Flete				Numeric(18,6) NULL,
	Poliza_Numero		varchar(50) NULL,
	Factura_No			varchar(50) NULL,
	Fecha_Documento		datetime null,
	Fecha_Vencimiento	datetime null,
	Fecha_Sistema		datetime null,
	Fecha_Ampliacion	datetime NULL,
	id_error			INT NULL,
	fecha_proceso		datetime,
	PRIMARY KEY(Id_Documento,Import_Export)
)
GO

CREATE INDEX inx_mgr_documento_pk ON dbo.tbl_mgr_documento (Id_Documento)
GO

CREATE INDEX inx_mgr_documento ON dbo.tbl_mgr_documento (Import_Export,Id_Cliente)
GO
