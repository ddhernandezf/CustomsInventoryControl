CREATE TABLE [dbo].[tbl_mgr_error]
(
	id_error		INT NOT NULL identity,
	id_referencia	INT NOT NULL,
	error			text NOT NULL,
	fecha_error		datetime null,
    ErrorLine		INT,
	ErrorNumber		INT,
    ErrorProcedure	nvarchar(200),
    ErrorMessage	nvarchar(4000),
    ErrorSeverity	INT,
    ErrorState		INT,
	PRIMARY KEY(id_error)
)