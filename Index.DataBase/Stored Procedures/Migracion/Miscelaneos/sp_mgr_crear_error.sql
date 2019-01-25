CREATE PROCEDURE sp_mgr_crear_error(@Mensaje varchar(2000), @IdRef INT, @SqlErr BIT, @Id INT output)
AS
BEGIN
	IF @SqlErr = 0
	Begin
		INSERT INTO TBL_MGR_ERROR (Error,id_referencia,fecha_error)
			values(@Mensaje,@IdRef,GETDATE());
	End
	ELSE
	Begin
		INSERT INTO TBL_MGR_ERROR (Id_Referencia,Error,fecha_error,ErrorNumber,ErrorSeverity,ErrorState,ErrorLine,ErrorProcedure,ErrorMessage)
			values(@IdRef,
				@Mensaje,GETDATE(),
				ERROR_NUMBER(),
				ERROR_SEVERITY(),
				ERROR_STATE(),
				ERROR_LINE(),
				ERROR_PROCEDURE(),
				ERROR_MESSAGE());
	End
	SET @Id = ISNULL(@@IDENTITY,-1);
end;