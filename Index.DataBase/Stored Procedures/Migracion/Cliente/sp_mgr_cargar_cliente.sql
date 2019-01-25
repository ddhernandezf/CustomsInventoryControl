CREATE PROCEDURE [dbo].[sp_mgr_cargar_cliente]
	@Result numeric(6,0) output
AS
BEGIN
	Declare	@Mensaje	nvarchar(max),
			@Id_Error	INT,
			@Const		varchar(10) = 'constancia';
	Declare @vClienteId INT = 0,
			@Nombre		varchar(250),
			@Cod_Cli	varchar(50),
			@Constancia	BIT,
			@vMigrar	bit = 0;
	Declare @IdPer INT = 0,
			@IdAcc INT = 0,
			@CntRes INT = 0;

	SET XACT_ABORT ON;

	Begin Try
		Begin transaction;
		--Excluyo los clientes que no se van a migrar y tienen datos, marcandolos con -1 en un campo sin uso
		UPDATE DBIndexIE..Cliente
			SET Cantidad_Minima = -1
		WHERE Id_Cliente IN(159,173,125,68)
		--commit transaction;
		--Begin transaction;
		insert into tbl_mgr_cliente (id_cliente,nombre,direccion,nit,codigo_cliente,Codigo_Impor_Expor,constancia)
		select Id_Cliente,
			Nombre,
			Direccion,
			nit,
			case when Cantidad_Minima < 0 then 'No_Migrar' else
			codigo_cliente end codigo_cliente,
			codigo_importador_exportador,
			case when charindex('constancia',nombre) > 0 then 1 else 0 end constancia
		from dbindexie.dbo.cliente
		--where id_cliente = 45
		commit transaction;
		set @Result = @@ROWCOUNT;

	End Try
	Begin Catch
		IF (XACT_STATE() = -1)
		BEGIN  
			PRINT  
				N'sp_mgr_cargar_cliente --> The transaction is in an uncommittable state.' +  
				N'sp_mgr_cargar_cliente --> Rolling back transaction.'  
			ROLLBACK TRANSACTION;
			Begin Transaction;
		END;  
  
		-- Test whether the transaction is committable.  
		IF (XACT_STATE() = 1)
		BEGIN  
			PRINT  
				N'sp_mgr_cargar_cliente --> The transaction is committable.' +  
				N'sp_mgr_cargar_cliente --> Committing transaction.'  
			COMMIT TRANSACTION;     
			Begin Transaction;
		END;
		set @Mensaje =  'Error insertando clientes de migracion en tabla temporal';
		exec dbo.sp_mgr_crear_error @Mensaje, 0, 1, @Id_Error output;
		commit transaction;
	End Catch

	--Empiezo a migrar los componentes para cada fila insertada
	DECLARE ClienteCursor CURSOR FOR
      SELECT id_cliente,nombre,constancia,codigo_cliente
        FROM tbl_mgr_cliente
		ORDER BY Constancia, Nombre

    OPEN ClienteCursor
    FETCH NEXT FROM ClienteCursor 
	INTO @vClienteId, @Nombre, @Constancia, @Cod_Cli
    WHILE @@FETCH_STATUS = 0
	Begin

		SET @vMigrar = (
			SELECT COUNT(1)
			FROM dbindexie..Cliente T1
			WHERE T1.Id_Cliente = @vClienteId
				and (Cantidad_Minima >= 0 or Cantidad_Minima is null)
				and exists (select 1
						from dbindexie..Cabecera_Importacion ts1, dbindexie..Detalle_Importacion ts2
						where ts2.Id_Cabecera_Importacion = ts1.Id_Cabecera_Importacion
							and ts1.Id_Cliente = t1.Id_Cliente
							and ts2.Estado <> 'A'
							and ts1.Estado <> 'A')
				and exists (select 1
						from dbindexie..Cabecera_Exportacion ts1, dbindexie..Detalle_Exportacion ts2
						where ts2.Id_Cabecera_Exportacion = ts1.Id_Cabecera_Exportacion
							and ts1.Id_Cliente = t1.Id_Cliente
							and ts2.Estado <> 'A'
							and ts1.Estado <> 'A')
		)

		IF @vMigrar > 0
		Begin
			Print N'Este cliente vamos a migrar (' + ltrim(rtrim(str(@vClienteId))) + ') ' + @Nombre
			exec dbo.sp_mgr_crear_cliente @vClienteId, @Constancia, @IdPer output, @IdAcc output


			if (@IdPer is not null) and (@IdAcc is not null)
			Begin
				exec dbo.sp_mgr_resolucion @vClienteId, @IdPer, @IdAcc, @CntRes output
				Print N'Cantidad resoluciones para cliente (' + ltrim(rtrim(str(@vClienteId))) + ')  --> ' + str(@CntRes)

				UPDATE TBL_MGR_CLIENTE SET Id_Person = @IdPer, Id_Account = @IdAcc where id_cliente = @vClienteId;
			End
			Else
			Begin
				set @Mensaje =  'La insercion del cliente fallo en la nueva estructura';
				exec dbo.sp_mgr_crear_error @Mensaje, @vClienteId, 0, @Id_Error output;
				update TBL_MGR_CLIENTE SET Id_Error = @Id_Error WHERE Id_Cliente = @vClienteId;
			End
		End
		ELSE
		Begin
			set @Mensaje =  @Cod_Cli + ' --> No tiene documentos para ser migrado';

			if (@Cod_Cli = 'No_Migrar')
				set @Mensaje =  @Cod_Cli + ' --> Este cliente fue marcado para no ser migrado';

			exec dbo.sp_mgr_crear_error @Mensaje, @vClienteId, 0, @Id_Error output;
			update TBL_MGR_CLIENTE SET Id_Error = @Id_Error WHERE Id_Cliente = @vClienteId;
		End

		UPDATE TBL_MGR_CLIENTE SET Fecha_Proceso = getdate() WHERE Id_Cliente = @vClienteId;

		FETCH NEXT FROM ClienteCursor INTO @vClienteId, @Nombre, @Constancia, @Cod_Cli
	END;

	CLOSE ClienteCursor;
	DEALLOCATE ClienteCursor;

	-- Asociar los clientes con los usuarios
	Insert into CustomerUser
	select a.IdPerson,b.UserName,getdate(), dbo.fn_mgr_user()
	from Customer a, [User] b;

END