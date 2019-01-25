CREATE TABLE [dbo].[tbl_mgr_garantia]
(
	id_garantia		INT NOT NULL,
	idWarranty		INT NULL,
	Id_Error		int null,
	fecha_proceso	datetime null,
	PRIMARY KEY(id_garantia)
)
GO

CREATE TRIGGER tgr_mgr_garantia ON TBL_MGR_GARANTIA
AFTER INSERT
AS
BEGIN
	Declare @IdGarantia INT = 0,
			@IdWarranty INT = 0;

	DECLARE GarantiaCursor CURSOR FOR
      SELECT Id_Garantia
        FROM inserted

    OPEN GarantiaCursor
    FETCH NEXT FROM GarantiaCursor INTO @IdGarantia
    WHILE @@FETCH_STATUS = 0
	Begin
		if (select count(1)
			from Warranty
			where replace(ltrim(rtrim(lower(Warranty.Name))),' ','') COLLATE DATABASE_DEFAULT = (select replace(ltrim(rtrim(lower(descripcion))),' ','') from DBIndexIE..Garantia where Id_Garantia =@IdGarantia)
			) = 0
		Begin
			INSERT INTO Warranty(Name,Description,RegisterDate,RegisterUser)
			SELECT t1.Descripcion,
				t1.Descripcion,
				getdate(),
				dbo.fn_mgr_user()
			FROM DBIndexIE..Garantia t1
			WHERE t1.Id_Garantia = @IdGarantia;

			UPDATE TBL_MGR_GARANTIA SET Fecha_Proceso = getdate(), idWarranty = @@IDENTITY WHERE Id_Garantia = @IdGarantia;
		End
		ELSE
		Begin
			set @IdWarranty = (select Id
							from Warranty
							where replace(ltrim(rtrim(lower(Warranty.Name))),' ','') COLLATE DATABASE_DEFAULT = 
								(select replace(ltrim(rtrim(lower(descripcion))),' ','') from DBIndexIE..Garantia where Id_Garantia = @IdGarantia))
			
			UPDATE TBL_MGR_GARANTIA SET Fecha_Proceso = getdate(), IdWarranty = @IdWarranty WHERE Id_Garantia = @IdGarantia;
		End
		FETCH NEXT FROM GarantiaCursor INTO @IdGarantia
	END;

	CLOSE GarantiaCursor;
	DEALLOCATE GarantiaCursor;
END;