CREATE PROCEDURE [dbo].[sp_mgr_transmision]
	@Result numeric(6,0) output
AS
BEGIN
	Declare	@Mensaje		nvarchar(max),
			@Id_Error		INT;
	Declare @CNS_Estado		varchar(10) = 'Ingresado';
	declare @T_Documento table(
		Id_Tipo_Documento	INT NOT NULL,
		IdFileInfoConfig	INT NOT NULL,
		Imp_Exp				BIT NOT NULL
	)
	declare @T_Moneda table(
		Id_Moneda	INT NOT NULL,
		IdCurrency	INT NOT NULL
	)

	SET XACT_ABORT ON;

	Begin Try
		Begin transaction;
			delete tbl_mgr_transmision
		commit tran;

		Begin transaction;
			Insert INTO TBL_MGR_TRANSMISION (Id_Transmision, Id_Usuario, Id_Cliente, Fecha_Sistema, Fecha_Inicial, Fecha_Final)
			select tt.Id_Transmision, tt.Id_Usuario, tt.Id_Cliente, tt.Fecha_Sistema, tt.Fecha_Inicial, tt.Fecha_Final
			from DBIndexIE..Transmision tt
			where exists(select 1
					from DBIndexIE..Log_Transmision lt
					where lt.Id_Transmision = tt.Id_Transmision
						and exists (select 1
								from DBIndexIE..Relacion_Detalle rd
								where rd.Id_Relacion_Detalle = lt.Id_Relacion_Detalle
									and rd.Estado <> 'A')
					)		
		set @Result = @@ROWCOUNT;
		commit transaction;

		PRINT N' Cantidad insertados tabla temporal: ' + str(@Result)

	End Try
	Begin Catch
		IF (XACT_STATE() = -1)
		BEGIN  
			PRINT  
				N'sp_mgr_cargar_documento --> The transaction is in an uncommittable state.' +  
				N'sp_mgr_cargar_documento --> Rolling back transaction.'  
			ROLLBACK TRANSACTION;
			Begin Transaction;
		END;  
  
		-- Test whether the transaction is committable.  
		IF (XACT_STATE() = 1)
		BEGIN  
			PRINT  
				N'sp_mgr_cargar_documento --> The transaction is committable.' +  
				N'sp_mgr_cargar_documento --> Committing transaction.'  
			COMMIT TRANSACTION;     
			Begin Transaction;
		END;
		set @Mensaje =  'Error insertando cabeceras de lotes transmitidos a OPA ONLINE para migracion en tabla temporal';
		exec dbo.sp_mgr_crear_error @Mensaje, 0, 1, @Id_Error output;
		commit transaction;
	End Catch

	if not exists (select * from [User] where UserName = dbo.fn_mgr_user())
	begin
		declare @vUser varchar(30) = dbo.fn_mgr_user();
		exec dbo.spi_User 'Migracion', 'Usuario', null, @vUser, 'j(m)y5vmR8Q5w(i)', 'j(m)y5vmR8Q5w(i)', 0, 0, 0, 0, 'SYS_USER'
	end

	begin tran;
		INSERT INTO OpaHeader (UserName, IdCustomer, IdAccount, IdPriority, IdState, StartDateHeader, EndDateHeader, EnterpriseCode, Nit, ImporterCode, ExporterCode,
							StartDate, EndDate, RegisterUser, RegisterDate)
		select dbo.fn_mgr_user(), 
			tmc.id_person, tmc.id_Account,
			(select Id from Priority where name = 'Baja'),
			1,
			tmt.Fecha_Inicial, tmt.Fecha_Final,
			tmc.Codigo_Cliente,
			tmc.Nit,
			tmc.Codigo_Impor_Expor,tmc.Codigo_Impor_Expor,
			tmt.Fecha_Inicial, tmt.Fecha_Final,
			dbo.fn_mgr_user(),
			tmt.Fecha_Sistema
		--select *
		from tbl_mgr_transmision tmt
			INNER JOIN tbl_mgr_cliente tmc ON tmc.id_cliente = tmt.Id_Cliente
		where tmt.Id_Transmision in(select lt.Id_Transmision
							from DBIndexIE..Log_Transmision lt
								INNER JOIN DBIndexIE..Transmision tr ON tr.Id_Transmision = lt.Id_Transmision
							where exists (select 1
										from DBIndexIE..Relacion_Detalle rd
										where rd.Id_Relacion_Detalle = lt.Id_Relacion_Detalle
											and rd.Estado <> 'A')
								and exists(select 1
										from tbl_mgr_cliente tmc
										where tmc.id_cliente = tr.Id_Cliente
											and tmc.id_person is not null)
							)
	commit tran;

	begin tran;
		UPDATE TBL_MGR_TRANSMISION
			SET IdOpaHeader = oh.Id,
				IdCustomer = oh.IdCustomer,
				IdAccount = oh.IdAccount
		FROM TBL_MGR_TRANSMISION tmt
			INNER JOIN tbl_mgr_cliente tmc ON tmc.id_cliente = tmt.Id_Cliente
			INNER JOIN OpaHeader oh 
				ON oh.IdCustomer = tmc.id_person
					and oh.IdAccount = tmc.id_Account
					and oh.StartDate = tmt.Fecha_Inicial
					and oh.EndDate = tmt.Fecha_Final
		where tmt.Id_Transmision in(select lt.Id_Transmision
							from DBIndexIE..Log_Transmision lt
								INNER JOIN DBIndexIE..Transmision tr ON tr.Id_Transmision = lt.Id_Transmision
							where exists (select 1
										from DBIndexIE..Relacion_Detalle rd
										where rd.Id_Relacion_Detalle = lt.Id_Relacion_Detalle
											and rd.Estado <> 'A')
								and exists(select 1
										from tbl_mgr_cliente tmc
										where tmc.id_cliente = tr.Id_Cliente
											and tmc.id_person is not null)
							)
	commit tran;

END;