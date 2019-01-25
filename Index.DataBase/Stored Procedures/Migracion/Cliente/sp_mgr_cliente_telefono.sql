CREATE PROCEDURE [dbo].[sp_mgr_cliente_telefono]
(
				@IdPerson		INT,
				@Telefono		varchar(50), 
				@TipoTel		varchar(30),
				@Delimitador	varchar(10))
AS
BEGIN

SET XACT_ABORT ON;

	Declare @Mensaje	nvarchar(max),
			@Valor		nvarchar(max),
			@Valor_Num	varchar(30),
			@Valor_Tmp	varchar(30),
			@vResp		BIT;
	Declare @Id_Error	INT,
			@Num_Ori	INT = 0,
			@Num_Des	INT = 0,
			@Cont		INT = 1;

Begin Try

	--Inserto los numeros de telefono, reviso que existan los tipos
	if not exists (select 1 from phonetype where lower(description) like '%'+@TipoTel+'%')
		insert into phonetype (description) values(@TipoTel)


	IF (select count(1) from dbo.fn_mgr_split_string(lower(@Telefono),@Delimitador)
	) > 1
	BEGIN
		DECLARE PhoneCursor CURSOR LOCAL FOR
			select valor 
			from dbo.fn_mgr_split_string(lower(@Telefono),@Delimitador)

		OPEN PhoneCursor
		FETCH NEXT FROM PhoneCursor INTO @Valor
		WHILE @@FETCH_STATUS = 0
		BEGIN
			if (select charindex('al',lower(@Valor))) > 0
				exec dbo.sp_mgr_cliente_telefono @IdPerson, @Valor, @TipoTel, 'al'
			else
			Begin
				if (charindex('y',lower(@Valor))) > 0
					exec dbo.sp_mgr_cliente_telefono @IdPerson, @Valor, @TipoTel, 'y'
				else
				Begin
					if (charindex(' ',ltrim(rtrim((@Valor))))) > 0
						exec dbo.sp_mgr_cliente_telefono @IdPerson, @Valor, @TipoTel, ' '
					else
					Begin
						 set @Valor = dbo.fn_mgr_RemoveChars(@Valor)
--						 Print N' Entra a revisar el valor ya sin recursivdad ' + @Valor
						
						 -- Numeros con longitud aceptable para ser un telefono para la primer fila de split
						 if (LEN(@Valor) >=8 and LEN(@Valor) < 12)
						 Begin
--							Print N'if (LEN(@Valor) >=8 and LEN(@Valor) < 12)'
							Set @Valor_Num = dbo.fn_mgr_RemoveChars(@Valor)
							exec dbo.sp_mgr_insertar_telefono @IdPerson, @Valor_Num, @TipoTel, @vResp output
						 End
						
						 -- Numeros agregados como adicionales de la PBX con / o la letra Y
						 if ((LEN(@Valor) <=2) and ((@Delimitador = '/') OR (@Delimitador = 'y')))
						 Begin
--							Print N'if ((LEN(@Valor) <=2) and ((@Delimitador = /) OR (@Delimitador = y)))'
							Set @Valor_Num = substring(@Valor_Num, 1, 6) + dbo.fn_mgr_RemoveChars(@Valor)
							exec dbo.sp_mgr_insertar_telefono @IdPerson, @Valor_Num, @TipoTel, @vResp output
						End

						-- Numeros que forman parte de otro pero estan separados por guion
						if ((LEN(@Valor) > 2) and (LEN(@Valor) < 8 ) and (@Delimitador = '-'))
						Begin
--							Print N'if ((LEN(@Valor) > 2) and (LEN(@Valor) < 8 ) and (@Delimitador = -))'
							if (@Valor_Tmp is not null)
							Begin
								set @Valor_Num = @Valor_Tmp + @Valor
								exec dbo.sp_mgr_insertar_telefono @IdPerson, @Valor_Num, @TipoTel, @vResp output
								set @Valor_Tmp = NULL
							End
							else
								Set @Valor_Tmp = dbo.fn_mgr_RemoveChars(@Valor)
						End
						
						if ((LEN(@Valor) <=2) and ((@Delimitador = 'al') or (@Delimitador = '-')))
						Begin
--							Print N'if ((LEN(@Valor) <=2) and (@Delimitador = al) or (@Delimitador = -))'
							set @Num_Ori = convert(int, substring(@Valor_Num, 7,2))
							set @Num_Des = convert(int, dbo.fn_mgr_RemoveChars(@Valor))
							While @Cont <= (@Num_Des - @Num_Ori)
							Begin
								set @Valor_Num = substring(@Valor_Num, 1, 6) + ltrim(rtrim(str(@Num_Ori+@Cont)))
								exec dbo.sp_mgr_insertar_telefono @IdPerson, @Valor_Num, @TipoTel, @vResp output

								set @Cont = @Cont + 1
							End
						End
					End
				End
			End
			FETCH NEXT FROM PhoneCursor INTO @Valor
		END;
		CLOSE PhoneCursor;
		DEALLOCATE PhoneCursor;
	End
	ELSE
	Begin
--		Print N' No tiene el delimitador'
		IF (LEN(ltrim(rtrim(@Telefono)))) <=10
		Begin
			Set @Valor_Num = dbo.fn_mgr_RemoveChars(@Telefono)
			exec dbo.sp_mgr_insertar_telefono @IdPerson, @Valor_Num, @TipoTel, @vResp output
		End
		else
		Begin
--			Print N'Mandara de nuevo el valor con guion ' + @Telefono
			exec dbo.sp_mgr_cliente_telefono @IdPerson, @Telefono, @TipoTel, '-'
		End
	END
End Try
Begin Catch
	IF (XACT_STATE() = -1)
	BEGIN  
		PRINT  
			N'sp_mgr_cliente_telefono --> The transaction is in an uncommittable state.' +  
			N'sp_mgr_cliente_telefono --> Rolling back transaction.'  
		ROLLBACK TRANSACTION;
		Begin Transaction;
	END;  
  
	-- Test whether the transaction is committable.  
	IF (XACT_STATE() = 1)
	BEGIN  
		PRINT  
			N'sp_mgr_cliente_telefono --> The transaction is committable.' +  
			N'sp_mgr_cliente_telefono --> Committing transaction.'  
		COMMIT TRANSACTION;     
		Begin Transaction;
	END;
	set @Mensaje =  'Error insertando telefonos para cliente (' + str(@IdPerson)+ ')';
	exec dbo.sp_mgr_crear_error @Mensaje, @IdPerson, 1, @Id_Error output;
	commit transaction;
End Catch

end