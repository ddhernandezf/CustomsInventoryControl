CREATE TABLE [dbo].[tbl_mgr_aduana]
(
	id_aduana		INT NOT NULL,
	id_custom		INT NULL,
	Id_Error		int null,
	fecha_proceso	datetime null,
	PRIMARY KEY(id_aduana)
)
GO

CREATE TRIGGER tgr_mgr_aduana ON TBL_MGR_ADUANA
AFTER INSERT
AS
BEGIN
	Declare @IdAduana INT = 0,
			@IdCustom INT = 0;

	DECLARE AduanaCursor CURSOR FOR
      SELECT Id_Aduana
        FROM inserted

    OPEN AduanaCursor
    FETCH NEXT FROM AduanaCursor INTO @IdAduana
    WHILE @@FETCH_STATUS = 0
	Begin
		if (select count(1)
			from Customs
			where replace(ltrim(rtrim(lower(customs.Name))),' ','') COLLATE DATABASE_DEFAULT = (select replace(ltrim(rtrim(lower(descripcion))),' ','') from DBIndexIE..Aduana where Id_Aduana =@IdAduana)
			) = 0
		Begin
			if (select count(1)
				from Customs
				where ltrim(rtrim(lower(customs.Name))) COLLATE DATABASE_DEFAULT like '%' + (select replace(ltrim(rtrim(lower(descripcion))),' ','%') from DBIndexIE..Aduana where Id_Aduana =@IdAduana) +'%' 
			) = 1
			Begin
				--Print N'Va actualizar con el like ' + ltrim(rtrim(str(@IdAduana)))
				set @IdCustom = (select Id
								from Customs
								where ltrim(rtrim(lower(customs.Name))) COLLATE DATABASE_DEFAULT like '%' + 
									(select replace(ltrim(rtrim(lower(descripcion))),' ','%') from DBIndexIE..Aduana where Id_Aduana =@IdAduana) +'%') 
			
				UPDATE Customs SET Code = ltrim(rtrim(str(@IdAduana))) where Id = @IdCustom;

				UPDATE TBL_MGR_ADUANA SET Fecha_Proceso = getdate(), id_custom = @IdCustom WHERE Id_Aduana = @IdAduana;
			End
			Else
			Begin
				--Print N'Va insertar con el registro ' + ltrim(rtrim(str(@IdAduana)))
				SET IDENTITY_INSERT [Customs] OFF;
				INSERT INTO Customs (IdCountry, Name, Address, Code, RegisterDate, RegisterUser)
				SELECT (select id from Country where lower(name) ='guatemala'),
					t1.Descripcion,
					t1.Descripcion,
					ltrim(rtrim(STR(T1.Id_Aduana))),
					getdate(),
					dbo.fn_mgr_user()
				FROM DBIndexIE..Aduana t1
				WHERE t1.Id_Aduana = @IdAduana;

				UPDATE TBL_MGR_ADUANA SET Fecha_Proceso = getdate(), id_custom = @@IDENTITY WHERE Id_Aduana = @IdAduana;
				SET IDENTITY_INSERT [Customs] ON;
			End
		End
		ELSE
		Begin
			--Print N'Va actualizar con el match exacto el registro ' + ltrim(rtrim(str(@IdAduana)))
			set @IdCustom = (select Id
							from Customs
							where replace(ltrim(rtrim(lower(customs.Name))),' ','') COLLATE DATABASE_DEFAULT = 
								(select replace(ltrim(rtrim(lower(descripcion))),' ','') from DBIndexIE..Aduana where Id_Aduana =@IdAduana))
			
			UPDATE Customs SET Code = ltrim(rtrim(str(@IdAduana))) where Id = @IdCustom;

			UPDATE TBL_MGR_ADUANA SET Fecha_Proceso = getdate(), id_custom = @IdCustom WHERE Id_Aduana = @IdAduana;
		End
		FETCH NEXT FROM AduanaCursor INTO @IdAduana
	END;

	CLOSE AduanaCursor;
	DEALLOCATE AduanaCursor;
END;