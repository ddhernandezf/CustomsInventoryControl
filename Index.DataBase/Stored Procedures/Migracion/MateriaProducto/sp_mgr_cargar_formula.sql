CREATE PROCEDURE [dbo].[sp_mgr_cargar_formula]
	@IdProducto	INT,
	@IdMaintem	INT,
	@Result bit output
AS
BEGIN
	Declare	@Mensaje		nvarchar(max),
			@Id_Error		INT,
			@Cant			INT = 0;
	Declare @Id_MP			INT,
			@IdDetailtem	INT,
			@Cantidad		numeric(18,6),
			@Cantidad_Merma	numeric(18,6);

	SET XACT_ABORT ON;

	if (select count(1)
		from DBIndexIE..Formula f
		where f.Id_Producto = @IdProducto) > 0
	Begin

		Print N'Se comienza la insercion de la formula para el producto ' + ltrim(rtrim(str(@IdProducto )))

		DECLARE FormulaCursor CURSOR FOR
		  SELECT Id_Materia_Prima,Cantidad,Cantidad_Merma
			FROM DBIndexIE..Formula
			WHERE Id_Producto = @IdProducto

		OPEN FormulaCursor
		FETCH NEXT FROM FormulaCursor
		INTO @Id_MP,@Cantidad,@Cantidad_Merma
		WHILE @@FETCH_STATUS = 0
		Begin
		
			set @IdDetailtem = (select tmp.iditem 
						from tbl_mgr_materia_producto tmp 
						where tmp.id_Materia_Producto = @Id_MP
							and tmp.Producto = 0
							and tmp.IdItem is not null)
		
			if (@IdDetailtem is not null)
			Begin
				if (select count(1)
					from Formula
					where IdMainItem = @IdMaintem
						and IdDetailItem = @IdDetailtem
					) = 0
				Begin
					INSERT INTO Formula(IdMainItem,IdDetailItem,Quantity,Decrease,RegisterDate,RegisterUser)
							VALUES(
								@IdMaintem,
								@IdDetailtem,
								@Cantidad,
								@Cantidad_Merma,
								getdate(),
								dbo.fn_mgr_user()
								)
				End
			End
			Else
			Begin
				set @Mensaje =  'La materia prima ' + ltrim(rtrim(str(@Id_MP))) +') No se encontro en la tabla de migracion';
				exec dbo.sp_mgr_crear_error @Mensaje, @Id_MP, 0, @Id_Error output;
			End
			set @Cant += 1;
			FETCH NEXT FROM FormulaCursor INTO @Id_MP,@Cantidad,@Cantidad_Merma
		END;

		CLOSE FormulaCursor;
		DEALLOCATE FormulaCursor;
		Print N'Se insertaron ' + ltrim(rtrim(str(@Cant))) + ' materias primas como formula para el producto ' + ltrim(rtrim(str(@IdProducto)))
	end
	SET @Result = 1;
END