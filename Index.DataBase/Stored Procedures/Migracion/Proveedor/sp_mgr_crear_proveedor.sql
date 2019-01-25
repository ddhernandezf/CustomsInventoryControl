CREATE PROCEDURE [dbo].[sp_mgr_crear_proveedor]
	@IdProveedor INT, 
	@Destino BIT,
	@IdPersonOut INT output
AS
BEGIN
	Declare @tProveedor TABLE(
		Id_Proveedor int NOT NULL,
		Nombre varchar(250) NOT NULL,
		Nit varchar(25) NULL,
		Direccion varchar(250) NOT NULL,
		Telefono varchar(50) NULL,
		Fax varchar(50) NULL,
		Destino	BIT NULL
	);
	Declare @Telefono	varchar(50),
			@Mensaje	nvarchar(max);
	Declare @IdPerson	INT = NULL,
			@IdSupplier INT = NULL,
			@InsertNew	BIT = 1,
			@Id_Error	INT = 0;
	SET XACT_ABORT ON;  

Begin Try
	SET @IdPersonOut = NULL;

	INSERT INTO @tProveedor
	SELECT Id_Proveedor,Nombre,Nit,Direccion,Telefono,Fax,
		case when Local_Externo = 'P' then 0 else 1 end Destiny
	FROM DBIndexIE..PROVEEDOR WHERE Id_Proveedor = @IdProveedor;

	set @IdPerson = (select  IdPerson
					from Person t1, Supplier t2
					where t2.IdPerson = t1.Id
						and replace(ltrim(rtrim(lower(t1.EnterpriseName))),' ','') COLLATE DATABASE_DEFAULT = 
							(select replace(ltrim(rtrim(lower(Nombre))),' ','') from @tProveedor)
						--and dbo.fn_mgr_RemoveChars(t1.Nit) like '%' + (select IsNull(dbo.fn_mgr_RemoveChars(Nit),'') from @tCliente) + '%'
						--and t2.PersonCode like '''%'''+ (select IsNull(Codigo_Cliente,'') from @tCliente) +'''%'''
						--and t2.ImporterCode like '%' + (select IsNull(Codigo_Importador_Exportador,'') from @tCliente) +'%'
					);

	if @IdPerson IS NOT NULL
		set @InsertNew = 0

	IF @InsertNew = 1
	Begin
		--1 Inserto en la tabla persona, y guardo el id recien insertado
		INSERT INTO person(FirstName,nit,registerdate,registeruser,IsEnterprise,EnterpriseName)
		values (
			(select Nombre from @tProveedor),
			(select left(nit,15) from @tProveedor),
			getdate(),
			dbo.fn_mgr_user(),
			1,
			(select Nombre from @tProveedor)
		);
		set @IdPerson = @@IDENTITY;
	End

	--Inserto la direccion, reviso que el tipo
	if not exists (select 1 from AddressType where lower(description) like '%oficina%')
		insert into AddressType (description) values('Oficina')

	if (select count(1) from @tProveedor where (Direccion is not null or len(Direccion) >=5)) > 0
	Begin
		if not exists(select 1 from Address where IdPerson = @IdPerson and lower(Address) = (select Direccion from @tProveedor))
		Begin
			insert into Address (IdAddressType,IdPerson,Address,RegisterDate,RegisterUser)
			values(
				(select id from AddressType where lower(description) = 'oficina'),
				@IdPerson,
				(select Direccion from @tProveedor),
				getdate(),
				dbo.fn_mgr_user()
			)
		End
	End

	-- Guardo el telefono del cliente, manejando las cadenas del origen que solo describen los rangos.
	if (select count(1) from @tProveedor where (Telefono is not null or len(Telefono) >=8)) > 0
	Begin
		set @Telefono = (select lower(telefono) from @tProveedor)

		if charindex('/',@Telefono) > 0
			exec dbo.sp_mgr_cliente_telefono @IdPerson, @Telefono, 'oficina', '/'
		else
		Begin
			if charindex('al',@Telefono) > 0
				exec dbo.sp_mgr_cliente_telefono @IdPerson, @Telefono, 'oficina', 'al'
			else
			Begin
				if charindex('y',@Telefono) > 0
					exec dbo.sp_mgr_cliente_telefono @IdPerson, @Telefono, 'oficina', 'y'
				else
					exec dbo.sp_mgr_cliente_telefono @IdPerson, @Telefono, 'oficina', '@'
			End
		End
	End

	-- Guardo el fax del cliente, manejando las cadenas del origen que solo describen los rangos.
	if (select count(1) from @tProveedor where (Fax is not null or len(Fax) >=8)) > 0
	Begin
		set @Telefono = (select lower(fax) from @tProveedor)

		if charindex('/',@Telefono) > 0
			exec dbo.sp_mgr_cliente_telefono @IdPerson, @Telefono, 'fax', '/'
		else
		Begin
			if charindex('al',@Telefono) > 0
				exec dbo.sp_mgr_cliente_telefono @IdPerson, @Telefono, 'fax', 'al'
			else
			Begin
				if charindex('y',@Telefono) > 0
					exec dbo.sp_mgr_cliente_telefono @IdPerson, @Telefono, 'fax', 'y'
				else
					exec dbo.sp_mgr_cliente_telefono @IdPerson, @Telefono, 'fax', '@'
			End
		End
	End

	IF @InsertNew = 1
	Begin
		INSERT INTO Supplier(IdPerson,RegisterDate,RegisterUser,IsDestinySupplier)
		VALUES(
				@IdPerson,
				getdate(),
				dbo.fn_mgr_user(),
				@Destino
			);
	End

	SET @IdPersonOut = @IdPerson;


End Try
Begin Catch
	IF (XACT_STATE() = -1)
	BEGIN  
		PRINT  
			N'sp_mgr_crear_proveedor --> The transaction is in an uncommittable state.' +  
			N'sp_mgr_crear_proveedor --> Rolling back transaction.'  
		ROLLBACK TRANSACTION;
		Begin Transaction;
	END;  
  
	-- Test whether the transaction is committable.  
	IF (XACT_STATE() = 1)
	BEGIN  
		PRINT  
			N'sp_mgr_crear_proveedor --> The transaction is committable.' +  
			N'sp_mgr_crear_proveedor --> Committing transaction.'  
		COMMIT TRANSACTION;     
		Begin Transaction;
	END;
	set @Mensaje =  ERROR_MESSAGE();
	exec dbo.sp_mgr_crear_error @Mensaje, @IdProveedor, 1, @Id_Error output;

	SET @IdPersonOut = NULL;

	commit transaction;
End Catch
END