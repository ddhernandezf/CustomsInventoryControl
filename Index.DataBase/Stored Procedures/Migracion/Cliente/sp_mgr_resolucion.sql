CREATE PROCEDURE [dbo].[sp_mgr_resolucion]
	@IdCliente INT,
	@IdPerson INT,
	@IdAccount INT,
	@Result numeric(6,0) output
AS
BEGIN
	Declare	@Mensaje nvarchar(max),
			@Id_Error INT;

SET XACT_ABORT ON;

Begin Try

	if (select count(1)
		from DBIndexIE..Resolucion rs
		where rs.Id_Cliente = @IdCliente
	) > 0
	Begin
		INSERT INTO Resolution (IdCustomer,IdAccount,Name,Description,RateDate,RegisterDate,RegisterUser)
		select @IdPerson,
				@IdAccount,
				ltrim(rtrim(str(rn.id_resolucion))) +'-'+ ltrim(rtrim(rn.Descripcion)),
				ltrim(rtrim(rn.Descripcion)),
				rn.Fecha_Calificacion,
				getdate(),
				dbo.fn_mgr_user()
		from DBIndexIE..Resolucion rn,
			(select Id_Resolucion,Id_Cliente
			from DBIndexIE..Materia_Prima
			union all
			select Id_Resolucion,Id_Cliente
			from DBIndexIE..Producto) mp
		where mp.Id_Resolucion = rn.Id_Resolucion
			and mp.Id_Cliente = rn.Id_Cliente
			and rn.Id_Cliente = @IdCliente
		group by rn.Id_Resolucion,rn.Descripcion,rn.Fecha_Calificacion;

		set @Result = @@ROWCOUNT;
	End
End Try
Begin Catch
	IF (XACT_STATE() = -1)
	BEGIN  
		PRINT  
			N'sp_mgr_resolucion --> The transaction is in an uncommittable state.' +  
			N'sp_mgr_resolucion --> Rolling back transaction.'  
		ROLLBACK TRANSACTION;
		Begin Transaction;
	END;  
  
	-- Test whether the transaction is committable.  
	IF (XACT_STATE() = 1)
	BEGIN  
		PRINT  
			N'sp_mgr_resolucion --> The transaction is committable.' +  
			N'sp_mgr_resolucion --> committing transaction.'  
		COMMIT TRANSACTION;     
		Begin Transaction;
	END;
	set @Mensaje =  'Error insertando resoluciones para cliente (' + str(@IdCliente)+ ')';
	exec dbo.sp_mgr_crear_error @Mensaje, @IdCliente, 1, @Id_Error output;
	commit transaction;
End Catch
END