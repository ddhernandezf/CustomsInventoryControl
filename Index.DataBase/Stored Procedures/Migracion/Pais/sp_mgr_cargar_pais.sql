CREATE PROCEDURE [dbo].[sp_mgr_cargar_pais]
	@Result numeric(6,0) output
AS
BEGIN
	Declare	@Mensaje nvarchar(max),
			@Id_Error INT;
Begin Try
	Begin transaction;
	INSERT INTO tbl_mgr_pais (id_pais)
	select Id_Pais
	from DBIndexIE..Pais
	commit transaction;
	set @Result = @@ROWCOUNT;
End Try
Begin Catch
	IF (XACT_STATE() = -1)
	BEGIN  
		PRINT  
			N'The transaction is in an uncommittable state.' +  
			'Rolling back transaction.'  
		ROLLBACK TRANSACTION;
		Begin Transaction;
	END;  
  
	-- Test whether the transaction is committable.  
	IF (XACT_STATE() = 1)
	BEGIN  
		PRINT  
			N'The transaction is committable.' +  
			'Committing transaction.'  
		COMMIT TRANSACTION;     
		Begin Transaction;
	END;
	set @Mensaje =  'Error insertando paises para el sistema';
	exec dbo.sp_mgr_crear_error @Mensaje, 0, 1, @Id_Error output;
	commit transaction;
End Catch
END