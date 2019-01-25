CREATE PROCEDURE [dbo].[sp_mgr_cargar_mp]
	@Result numeric(6,0) output
AS
BEGIN
	Declare	@Mensaje		nvarchar(max),
			@Id_Error		INT;
	Declare @Id_MP			INT,
			@Id_Cliente		INT,
			@Descripcion	varchar(250),
			@Producto		bit,
			@Codigo			varchar(50),
			@Codigo_barras	varchar(50),
			@Id_UM			INT,
			@Id_Resolucion	INT,
			@Partida		varchar(50);
	Declare @IdItem			INT,
			@IdCustomer		INT,
			@IdAccount		INT,
			@IdUnitM		INT,
			@IdAccItem		INT,
			@IdResolution	INT;
	Declare @vMigrar		bit,
			@Migrado		bit = 0,
			@Materia_Prod	varchar(13);

	SET XACT_ABORT ON;

	Begin Try
		Begin transaction;
		delete tbl_mgr_materia_producto
		commit tran;
		Begin transaction;
		insert into tbl_mgr_materia_producto (id_materia_producto,producto,id_cliente,descripcion,codigo,codigo_barras,partida,id_resolucion,id_unidad_medida)
		select Id_Materia_Prima Id,0 Producto,Id_Cliente,Descripcion,Codigo,Codigo_Barras,Partida_Materia partida,Id_Resolucion,Id_Unidad_Medida
		from DBIndexIE..Materia_Prima
		where Id_Cliente in(select id_cliente from tbl_mgr_cliente where id_person is not null)
		union all
		select Id_producto Id,1,Id_Cliente,Descripcion,Codigo,Codigo_Barras,Partida_Producto partida,Id_Resolucion,Id_Unidad_Medida
		from DBIndexIE..Producto
		where Id_Cliente in(select id_cliente from tbl_mgr_cliente where id_person is not null)
		
		set @Result = @@ROWCOUNT;
		commit transaction;

	End Try
	Begin Catch
		IF (XACT_STATE() = -1)
		BEGIN  
			PRINT  
				N'sp_mgr_cargar_mp --> The transaction is in an uncommittable state.' +  
				N'sp_mgr_cargar_mp --> Rolling back transaction.'  
			ROLLBACK TRANSACTION;
			Begin Transaction;
		END;  
  
		-- Test whether the transaction is committable.  
		IF (XACT_STATE() = 1)
		BEGIN  
			PRINT  
				N'sp_mgr_cargar_mp --> The transaction is committable.' +  
				N'sp_mgr_cargar_mp --> Committing transaction.'  
			COMMIT TRANSACTION;     
			Begin Transaction;
		END;
		set @Mensaje =  'Error insertando materias productos para migracion en tabla temporal';
		exec dbo.sp_mgr_crear_error @Mensaje, 0, 1, @Id_Error output;
		commit transaction;
	End Catch

	--Empiezo a migrar los componentes para cada fila insertada
	DECLARE MPCursor CURSOR FOR
	  SELECT Id_materia_producto,Id_Cliente,descripcion,producto,codigo,codigo_barras,id_unidad_medida,id_Resolucion,partida
--	  select *
        FROM tbl_mgr_materia_producto
		--where Id_Materia_Producto <= 10
		ORDER BY Producto, Id_Cliente

    OPEN MPCursor
    FETCH NEXT FROM MPCursor 
	INTO @Id_MP,@Id_Cliente,@Descripcion,@Producto,@Codigo,@Codigo_Barras,@Id_UM,@Id_Resolucion,@Partida
    WHILE @@FETCH_STATUS = 0
	Begin

		If @Producto = 0
		Begin
			set @Materia_Prod = 'Materia Prima';

			set @vMigrar = (SELECT COUNT(1)
						FROM DBIndexIE..Materia_Prima mp
						where mp.Id_Materia_Prima = @Id_MP
							and len(ltrim(rtrim(mp.Descripcion)))>2
							/*and exists(select 1
									from DBIndexIE..Detalle_Importacion ts1
									where ts1.Id_Materia_Prima = mp.Id_Materia_Prima
										and ts1.Estado <> 'A')*/)
		End
		else
		Begin
			set @Materia_Prod = 'Producto';

			set @vMigrar = (SELECT COUNT(1)
						FROM DBIndexIE..Producto P
						where p.Id_Producto = @Id_MP
							and len(ltrim(rtrim(p.Descripcion)))>2
							/*and exists(select 1
									from DBIndexIE..Detalle_Exportacion ts1
									where ts1.Id_Producto = p.Id_Producto
										and ts1.Estado <> 'A')*/)
		End

		IF @vMigrar > 0
		Begin
			--- Voy a traer los datos del cliente para el insert
			select @IdCustomer = t1.id_person, 
					@IdAccount = t1.id_account
			from tbl_mgr_cliente t1
			where t1.id_cliente = @Id_Cliente;

			-- Revisamos la partida
			set @IdAccItem = (select ai.Id
							from AccountingItem ai
							where replace(ai.AccountingItem,'.','') = replace(@Partida,'.',''));

			if (@IdAccItem is null)
			Begin
				set @IdAccItem = (select ai.Id
								from AccountingItem ai
								where replace(ai.AccountingItem,'.','') = replace(substring(@Partida,1,8),'.',''));
			End
			if (@IdAccItem is null)
			Begin
				set @Mensaje =  'Id ' + @Materia_Prod + '('+ ltrim(rtrim(str(@Id_MP))) +') No se encontro su partida arancelaria (' + IsNull(@Partida,'-1') +')';
				exec dbo.sp_mgr_crear_error @Mensaje, @Id_MP, 0, @Id_Error output;
				UPDATE TBL_MGR_MATERIA_PRODUCTO SET id_error = @Id_Error, fecha_proceso = getdate() WHERE Id_Materia_Producto = @Id_MP and Producto = @Producto

				if (select count(1)
					from AccountingItem ai
					where ai.Description = 'NULO') = 0
				Begin
					INSERT INTO AccountingItem(AccountingItem,Description,Parent,Level,CustomDuties,Usable,RegisterDate,RegisterUser)
						VALUES('00.00.00.00',
							'NULO',
							NULL,
							1,
							0.00,
							0,
							getdate(),
							dbo.fn_mgr_user());
					set @IdAccItem = @@IDENTITY;
				End
				ELSE
				Begin
					set @IdAccItem = (SELECT ai.Id
									FROM AccountingItem ai
									WHERE ai.Description = 'NULO')
				End
			End
			--- Terminamos con la rutina de la partida
			
			--Empezamos con la rutina de las resoluciones	
			set @IdResolution = (select re.Id
								from Resolution re
								where re.RegisterUser = dbo.fn_mgr_user()
									and convert(int,replace(re.name,'-'+re.description,'')) = @Id_Resolucion)
			if (@IdResolution is null)
			Begin
				set @Mensaje =  'Id ' + @Materia_Prod + '('+ ltrim(rtrim(str(@Id_MP))) +') No se encontro su resolucion (' + ltrim(rtrim(str(IsNull(@Id_Resolucion,'-1')))) +')';
				exec dbo.sp_mgr_crear_error @Mensaje, @Id_MP, 0, @Id_Error output;
				UPDATE TBL_MGR_MATERIA_PRODUCTO SET id_error = @Id_Error, fecha_proceso = getdate() WHERE Id_Materia_Producto = @Id_MP and Producto = @Producto

				if(select count(1)
					from Resolution re
					where re.IdCustomer = @IdCustomer
						and re.IdAccount = @IdAccount
						and re.Name = '20170215-182') = 0
				Begin
					INSERT INTO Resolution (IdCustomer,IdAccount,Name,Description,RateDate,RegisterDate,RegisterUser)
						VALUES(@IdCustomer,@IdAccount,
								'20170215-182','182',
								getdate(),getdate(),
								dbo.fn_mgr_user());

					set @IdResolution = @@IDENTITY;
				End
				ELSE
				Begin
					set @IdResolution = (SELECT re.Id
										FROM Resolution re
										WHERE re.IdCustomer = @IdCustomer
											and re.IdAccount = @IdAccount
											and re.Name = '20170215-182')
				End
			End
			--Terminados con la rutina de las resoluciones	

			-- Revisamos la relacion de la resolucion y partida arancelaria
			Print N'Partida: --> ' + ltrim(rtrim(str(@IdAccItem))) + ' Resolucion: --> ' + ltrim(rtrim(str(@IdResolution)))
			if ((@IdAccItem is not null) and (@IdResolution is not null))
			Begin
				if (select count(1)
					from ResolutionAccountingItem rai
					where rai.IdAccountingItem = @IdAccItem
						and rai.IdResolution = @IdResolution
					) = 0
				Begin
					insert into ResolutionAccountingItem(IdResolution,IdAccountingItem)
						values(@IdResolution,@IdAccItem)
				End 
			End

			set @IdUnitM = (select t1.IdUnitMeasurement
							from tbl_mgr_um t1
							where t1.Id_Unidad_Medida = @Id_UM)
			if (@IdUnitM is null)
			Begin
				set @Mensaje =  'Id ' + @Materia_Prod + '('+ ltrim(rtrim(str(@Id_MP))) +') No se encontro su unidad de medida (' + IsNull(@Id_UM,'-1') +')';
				exec dbo.sp_mgr_crear_error @Mensaje, @Id_MP, 0, @Id_Error output;
				UPDATE TBL_MGR_MATERIA_PRODUCTO SET id_error = @Id_Error, fecha_proceso = getdate() WHERE Id_Materia_Producto = @Id_MP and Producto = @Producto
			End
			
			if (select count(1)
				from Item it
				where it.IdCustomer = @IdCustomer
					and it.name = @Descripcion
					and it.code = @Codigo
					and it.IsProduct = @Producto
					and it.IdUnitMeasurement = @IdUnitM
				) = 0
			Begin
				Begin tran;
					INSERT INTO Item (IdCustomer,IdResolution,IdAccountingItem,IdUnitMeasurement,Code,Name,Description,Barcode,IsProduct,RegisterDate,RegisterUser)
						VALUES(
							@IdCustomer,
							@IdResolution,
							@IdAccItem,
							@IdUnitM,
							@Codigo,
							@Descripcion,
							@Descripcion,
							@Codigo_barras,
							@Producto,
							getdate(),
							dbo.fn_mgr_user()
						)
				commit tran;
				set @IdItem = @@IDENTITY;
				
				Begin Tran;
					UPDATE TBL_MGR_MATERIA_PRODUCTO SET IdItem = @IdItem, IdPerson = @IdCustomer, fecha_proceso = getdate() WHERE Id_Materia_Producto = @Id_MP and Producto = @Producto
				commit tran;
			End
			Else
			Begin
				set @IdItem = (select Id
							from Item it
							where it.IdCustomer = @IdCustomer
								and it.name = @Descripcion
								and it.code = @Codigo
								and it.IsProduct = @Producto
								and it.IdUnitMeasurement = @IdUnitM)
				Begin Tran;
					UPDATE TBL_MGR_MATERIA_PRODUCTO SET IdItem = @IdItem, IdPerson = @IdCustomer, fecha_proceso = getdate() WHERE Id_Materia_Producto = @Id_MP and Producto = @Producto
				commit tran;
			End
			set @Migrado = 1;
		end
		ELSE
		Begin
			set @Mensaje =  'Id ' + @Materia_Prod + '('+ ltrim(rtrim(str(@Id_MP))) +') No cumple con las reglas minimas para ser migrado, no tiene registros o longitud';
			exec dbo.sp_mgr_crear_error @Mensaje, @Id_MP, 0, @Id_Error output;

			UPDATE TBL_MGR_MATERIA_PRODUCTO SET id_error = @Id_Error, fecha_proceso = getdate() WHERE Id_Materia_Producto = @Id_MP and Producto = @Producto
		End

		if @Producto = 1
		Begin
			exec dbo.sp_mgr_cargar_formula @Id_MP, @IdItem, @Migrado
		End

		set @IdAccItem = null
		set @IdResolution = null
		set @IdUnitM = null
		set @IdCustomer = null
		set @IdAccount = null
		set @IdItem = null

		FETCH NEXT FROM MPCursor INTO @Id_MP,@Id_Cliente,@Descripcion,@Producto,@Codigo,@Codigo_Barras,@Id_UM,@Id_Resolucion,@Partida
	END;

	CLOSE MPCursor;
	DEALLOCATE MPCursor;
	
	set @Result = 1;
	if @Migrado = 0
	Begin
		set @Result = 0;
		set @Mensaje =  'No se termino de ejecutar la migracion' + ltrim(rtrim(str(@Id_MP)));
		exec dbo.sp_mgr_crear_error @Mensaje, @Id_MP, 0, @Id_Error output;

		UPDATE TBL_MGR_MATERIA_PRODUCTO SET id_error = @Id_Error, fecha_proceso = getdate() WHERE Id_Materia_Producto = @Id_MP and Producto = @Producto
	End
END