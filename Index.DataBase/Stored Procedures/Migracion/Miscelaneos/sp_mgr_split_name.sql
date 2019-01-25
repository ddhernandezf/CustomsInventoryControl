CREATE PROCEDURE sp_mgr_split_name
	@pNombre	varchar(250), 
	@FirstName	varchar(250) output, 
	@LastName	varchar(250) output
AS
BEGIN

	Declare @Longitud numeric(3,0) = 150,
			@Pos tinyint = 0;
	Declare @Nombre varchar(250) = @pNombre;

	IF LEN(ltrim(rtrim(@Nombre))) <= @Longitud
	Begin
		SET @FirstName = @Nombre
		SET @LastName = NULL
	End
	ELSE
	Begin
		WHILE LEN(ltrim(rtrim(@Nombre))) > @Longitud
		Begin
			IF CHARINDEX(' ', REVERSE(@Nombre)) = 0
			Begin
				SET @FirstName = LEFT(@Nombre, @Longitud)
				IF Len(@Nombre) > @Longitud
					SET @LastName = RIGHT(@Nombre, LEN(@Nombre) - @Longitud)

				BREAK
			End
			ELSE
			Begin
				SET @Pos = CHARINDEX(' ', REVERSE(@Nombre))
				SET @FirstName = LEFT(@Nombre, LEN(@Nombre) - @Pos)
				SET @LastName = RIGHT(@Nombre, @Pos) + ISNULL(@LastName,'')
				SET @Nombre = @FirstName
			End
		End
	End
END;