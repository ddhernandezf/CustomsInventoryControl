CREATE TABLE [dbo].[tbl_mgr_pais]
(
	id_pais			INT NOT NULL,
	idCountry		INT NULL,
	Id_Error		int null,
	fecha_proceso	datetime null,
	PRIMARY KEY(id_pais)
)
GO

CREATE TRIGGER [tgr_mgr_pais] ON TBL_MGR_PAIS
AFTER INSERT
AS
BEGIN
	Declare @IdPais INT = 0,
			@IdCountry INT = 0;

	DECLARE PaisCursor CURSOR FOR
      SELECT Id_Pais
        FROM inserted

    OPEN PaisCursor
    FETCH NEXT FROM PaisCursor INTO @IdPais
    WHILE @@FETCH_STATUS = 0
	Begin
		if (select count(1)
			from Country
			where replace(ltrim(rtrim(lower(Country.Name))),' ','') COLLATE DATABASE_DEFAULT = (select replace(ltrim(rtrim(lower(descripcion))),' ','') from DBIndexIE..Pais where Id_Pais = @IdPais)
			) = 0
		Begin
			if (select count(1)
			from Country
			where ltrim(rtrim(lower(Country.Name))) COLLATE DATABASE_DEFAULT like '%' + (select replace(ltrim(rtrim(lower(descripcion))),' ','%') from DBIndexIE..Pais where Id_Pais = @IdPais) + '%'
			) = 1
			Begin
				set @IdCountry = (select Id
								from Country
								where ltrim(rtrim(lower(Country.Name))) COLLATE DATABASE_DEFAULT like '%' +  
									(select replace(ltrim(rtrim(lower(descripcion))),' ','%') from DBIndexIE..Pais where Id_Pais = @IdPais) + '%')
			
				UPDATE TBL_MGR_PAIS SET Fecha_Proceso = getdate(), IdCountry = @IdCountry WHERE Id_Pais = @IdPais;
			End
			Else
			Begin
				INSERT INTO Country(Name,IdParent,RegisterDate,RegisterUser)
				SELECT t1.Descripcion,
				0,
					getdate(),
					dbo.fn_mgr_user()
				FROM DBIndexIE..Pais t1
				WHERE t1.Id_Pais = @IdPais;

				UPDATE TBL_MGR_PAIS SET Fecha_Proceso = getdate(), IdCountry = @@IDENTITY WHERE Id_Pais = @IdPais;
			End
		End
		ELSE
		Begin
			set @IdCountry = (select Id
							from Country
							where replace(ltrim(rtrim(lower(Country.Name))),' ','') COLLATE DATABASE_DEFAULT = 
								(select replace(ltrim(rtrim(lower(descripcion))),' ','') from DBIndexIE..Pais where Id_Pais = @IdPais))
			
			UPDATE TBL_MGR_PAIS SET Fecha_Proceso = getdate(), IdCountry = @IdCountry WHERE Id_Pais = @IdPais;
		End
		FETCH NEXT FROM PaisCursor INTO @IdPais
	END;

	CLOSE PaisCursor;
	DEALLOCATE PaisCursor;
END