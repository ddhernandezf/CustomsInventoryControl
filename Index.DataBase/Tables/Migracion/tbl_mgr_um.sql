CREATE TABLE [dbo].[tbl_mgr_um]
(
	id_unidad_medida	INT NOT NULL,
	IdUnitMeasurement	INT NULL,
	Id_Error			int null,
	fecha_proceso		datetime null,
	PRIMARY KEY(id_unidad_medida)
)
GO

CREATE TRIGGER tgr_mgr_um ON TBL_MGR_UM
AFTER INSERT
AS
BEGIN
	Declare @IdUnidadMedida INT = 0,
			@IdUnitMeasurement INT = 0;

	DECLARE UMCursor CURSOR FOR
      SELECT Id_Unidad_Medida
        FROM inserted

    OPEN UMCursor
    FETCH NEXT FROM UMCursor INTO @IdUnidadMedida
    WHILE @@FETCH_STATUS = 0
	Begin
		if (select count(1)
			from UnitMeasurement
			where replace(ltrim(rtrim(lower(UnitMeasurement.Name))),' ','') COLLATE DATABASE_DEFAULT = (select replace(ltrim(rtrim(lower(descripcion))),' ','') from DBIndexIE..Unidad_Medida where Id_Unidad_Medida =@IdUnidadMedida)
			) = 0
		Begin
			if (select count(1)
				from UnitMeasurement
				where ltrim(rtrim(lower(UnitMeasurement.Name))) COLLATE DATABASE_DEFAULT like '%'+ (select replace(ltrim(rtrim(lower(descripcion))),' ','%') from DBIndexIE..Unidad_Medida where Id_Unidad_Medida = @IdUnidadMedida) + '%'
				) = 1
			Begin
				set @IdUnitMeasurement = (select Id
								from UnitMeasurement
								where ltrim(rtrim(lower(UnitMeasurement.Name))) COLLATE DATABASE_DEFAULT like '%' +
									(select replace(ltrim(rtrim(lower(descripcion))),' ','%') from DBIndexIE..Unidad_Medida where Id_Unidad_Medida = @IdUnidadMedida) + '%')
			
				UPDATE TBL_MGR_UM SET Fecha_Proceso = getdate(), IdUnitMeasurement = @IdUnitMeasurement WHERE Id_Unidad_Medida = @IdUnidadMedida;
			End
			Else
			Begin
				INSERT INTO UnitMeasurement(Name,Description,Symbol,RegisterDate,RegisterUser)
				SELECT t1.Descripcion,
					t1.Descripcion,
					substring(t1.Descripcion,1,3),
					getdate(),
					dbo.fn_mgr_user()
				FROM DBIndexIE..Unidad_Medida t1
				WHERE t1.Id_Unidad_Medida = @IdUnidadMedida;

				UPDATE TBL_MGR_UM SET Fecha_Proceso = getdate(), IdUnitMeasurement = @@IDENTITY WHERE Id_Unidad_Medida = @IdUnidadMedida;
			End
		End
		ELSE
		Begin
			set @IdUnitMeasurement = (select Id
							from UnitMeasurement
							where replace(ltrim(rtrim(lower(UnitMeasurement.Name))),' ','') COLLATE DATABASE_DEFAULT = 
								(select replace(ltrim(rtrim(lower(descripcion))),' ','') from DBIndexIE..Unidad_Medida where Id_Unidad_Medida = @IdUnidadMedida))
			
			UPDATE TBL_MGR_UM SET Fecha_Proceso = getdate(), IdUnitMeasurement = @IdUnitMeasurement WHERE Id_Unidad_Medida = @IdUnidadMedida;
		End
		FETCH NEXT FROM UMCursor INTO @IdUnidadMedida
	END;

	CLOSE UMCursor;
	DEALLOCATE UMCursor;
END