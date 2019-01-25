CREATE PROCEDURE [dbo].[sp_mgr_insertar_telefono]
	@IdPerson	INT, 
	@Telefono	varchar(50),
	@TipoTel	varchar(30),
	@Inserto	BIT output
AS
BEGIN
		SET @Inserto = 0

		if (select count(1)
			from Phone ph
			where ph.IdPerson = @IdPerson
				and ph.Number = @Telefono) = 0
		Begin
			insert into phone (number,IdPerson,IdPhoneType,RegisterDate,RegisterUser)
			values(
				@Telefono,
				@IdPerson,
				(select id from phonetype where lower(description) = @TipoTel),
				getdate(),
				dbo.fn_mgr_user()
			)
			Set @Inserto = 1;
			--Print N'Inserto en tabla telefono el telefono para el id Person: ' + str(@IdPerson)
		end
		else
			Print 'El telefono ya existe para la persona: ' + str(@IdPerson)
END