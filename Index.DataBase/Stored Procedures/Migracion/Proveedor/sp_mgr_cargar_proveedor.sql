CREATE PROCEDURE [dbo].[sp_mgr_cargar_proveedor]
	@Result numeric(6,0) output
AS
BEGIN
	Declare	@Mensaje	nvarchar(max),
			@Id_Error	INT;
	Declare @vProvId	INT = 0,
			@Nombre		varchar(250),
			@IsDestiny	bit = 0,
			@vMigrar	bit = 0;
	Declare @IdPer INT = 0,
			@CntRes INT = 0;

	SET XACT_ABORT ON;

	Begin Try
		Begin transaction;
		insert into tbl_mgr_proveedor (id_proveedor,nombre,direccion,nit,local_externo)
		select Id_Proveedor,
			Nombre,
			Direccion,
			nit,
			case when Local_Externo = 'P' then 0 else 1 end IsDestiny
		from dbindexie.dbo.Proveedor
		--where id_cliente = 45
		commit transaction;
		set @Result = @@ROWCOUNT;

	End Try
	Begin Catch
		IF (XACT_STATE() = -1)
		BEGIN  
			PRINT  
				N'sp_mgr_cargar_proveedor --> The transaction is in an uncommittable state.' +  
				N'sp_mgr_cargar_proveedor --> Rolling back transaction.'  
			ROLLBACK TRANSACTION;
			Begin Transaction;
		END;  
  
		-- Test whether the transaction is committable.  
		IF (XACT_STATE() = 1)
		BEGIN  
			PRINT  
				N'sp_mgr_cargar_proveedor --> The transaction is committable.' +  
				N'sp_mgr_cargar_proveedor --> Committing transaction.'  
			COMMIT TRANSACTION;     
			Begin Transaction;
		END;
		set @Mensaje =  'Error insertando proveedores de migracion en tabla temporal';
		exec dbo.sp_mgr_crear_error @Mensaje, 0, 1, @Id_Error output;
		commit transaction;
	End Catch

	--Empiezo a migrar los componentes para cada fila insertada
	DECLARE ProveedorCursor CURSOR FOR
      SELECT id_proveedor,nombre,local_externo
        FROM tbl_mgr_proveedor
		ORDER BY local_externo, Nombre

    OPEN ProveedorCursor
    FETCH NEXT FROM ProveedorCursor 
	INTO @vProvId, @Nombre, @IsDestiny
    WHILE @@FETCH_STATUS = 0
	Begin

		IF @IsDestiny = 0
		Begin
			SET @vMigrar = (
				SELECT COUNT(1) -- Proveedores
				FROM dbindexie..Proveedor T1
				WHERE T1.Id_Proveedor = @vProvId
					and exists (select 1
							from dbindexie..Cabecera_Importacion ts1, dbindexie..Detalle_Importacion ts2
							where ts2.Id_Cabecera_Importacion = ts1.Id_Cabecera_Importacion
								and ts1.Id_Proveedor = t1.Id_Proveedor
								and ts2.Estado <> 'A'
								and ts1.Estado <> 'A')
							)
		End
		ELSE
		Begin
			SET @vMigrar = (
				SELECT COUNT(1) -- clientes destino
				FROM dbindexie..Proveedor T1
				WHERE T1.Id_Proveedor = @vProvId
					and exists (select 1
							from dbindexie..Cabecera_Exportacion ts1, dbindexie..Detalle_Exportacion ts2
							where ts2.Id_Cabecera_Exportacion = ts1.Id_Cabecera_Exportacion
								and ts1.Id_Proveedor = t1.Id_Proveedor
								and ts2.Estado <> 'A'
								and ts1.Estado <> 'A')
							)
		end

		IF @vMigrar > 0
		Begin
			Print N'Este Proveedor vamos a migrar (' + ltrim(rtrim(str(@vProvId))) + ') ' + @Nombre
			exec dbo.sp_mgr_crear_proveedor @vProvId, @IsDestiny, @IdPer output

			if (@IdPer is not null)
			Begin
				UPDATE TBL_MGR_PROVEEDOR SET Id_Person = @IdPer where id_proveedor = @vProvId;
			End
			Else
			Begin
				set @Mensaje =  'La insercion del cliente fallo en la nueva estructura';
				exec dbo.sp_mgr_crear_error @Mensaje, @vProvId, 0, @Id_Error output;

				update TBL_MGR_PROVEEDOR SET Id_Error = @Id_Error WHERE Id_Proveedor = @vProvId;
			End
		End
		ELSE
		Begin
			set @Mensaje =  'No tiene documentos para ser migrado';

			exec dbo.sp_mgr_crear_error @Mensaje, @vProvId, 0, @Id_Error output;
			update TBL_MGR_PROVEEDOR SET Id_Error = @Id_Error WHERE Id_Proveedor = @vProvId;
		End

		UPDATE TBL_MGR_PROVEEDOR SET Fecha_Proceso = getdate() WHERE Id_Proveedor = @vProvId;

		FETCH NEXT FROM ProveedorCursor INTO @vProvId, @Nombre, @IsDestiny
	END;

	CLOSE ProveedorCursor;
	DEALLOCATE ProveedorCursor;


END