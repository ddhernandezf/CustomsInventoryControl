CREATE PROCEDURE [dbo].[sp_mgr_crear_cliente]
	@IdCliente INT, 
	@Constancia BIT,
	@IdPersonOut INT output,
	@IdAccntOut INT output
AS
BEGIN
	Declare @tCliente TABLE(
		Id_Cliente int NOT NULL,
		Nombre varchar(250) NOT NULL,
		Nit varchar(25) NULL,
		Direccion varchar(250) NOT NULL,
		Telefono varchar(50) NULL,
		Fax varchar(50) NULL,
		Representante_Legal varchar(250) NULL,
		Codigo_Cliente varchar(100) NOT NULL,
		Codigo_Importador_Exportador varchar(100) NULL,
		Resolucion_Calificacion varchar(100) NULL,
		Regimen_Calificacion varchar(100) NULL,
		Periodo_Fiscal varchar(100) NULL,
		Fecha_Resolucion datetime NULL,
		Fecha_Vencimiento datetime NULL,
		Cantidad_Minima numeric(18, 6) NULL
	);
	Declare @FName		varchar(150),
			@LName		varchar(150),
			@TName		varchar(250),
			@Telefono	varchar(50),
			@Mensaje	nvarchar(max);
	Declare @IdPerson	INT = NULL,
			@IdCustomer INT = NULL,
			@IdAccnt	INT = NULL,
			@InsertNew	BIT = 1,
			@Id_Error	INT = 0;
	SET XACT_ABORT ON;  

Begin Try
	SET @IdPersonOut = NULL;
	SET @IdAccntOut = NULL;

	INSERT INTO @tCliente 
	SELECT *
	FROM DBIndexIE..CLIENTE WHERE Id_Cliente = @IdCliente;

	set @TName = (select Nombre from @tCliente)

	exec sp_mgr_split_name @TName, @FName output, @LName output

	set @IdPerson = (select  IdPerson
					from Person t1, Customer t2
					where t2.IdPerson = t1.Id
						and dbo.fn_mgr_RemoveChars(t1.Nit) like '%' + (select IsNull(dbo.fn_mgr_RemoveChars(Nit),'') from @tCliente) + '%'
						--and t2.PersonCode like '''%'''+ (select IsNull(Codigo_Cliente,'') from @tCliente) +'''%'''
						--and t2.ImporterCode like '%' + (select IsNull(Codigo_Importador_Exportador,'') from @tCliente) +'%'
					);

	if @IdPerson IS NOT NULL
		set @InsertNew = 0

	IF @InsertNew = 1
	Begin
		--1 Inserto en la tabla persona, y guardo el id recien insertado
		INSERT INTO person(firstname,lastname,nit,registerdate,registeruser,IsEnterprise,EnterpriseName)
		values (
			@FName,
			@LName,
			(select nit from @tCliente),
			getdate(),
			dbo.fn_mgr_user(),
			1,
			@TName
		);
		set @IdPerson = @@IDENTITY;
	End

	--Inserto la direccion, reviso que el tipo
	if not exists (select 1 from AddressType where lower(description) like '%oficina%')
		insert into AddressType (description) values('Oficina')

	if (select count(1) from @tCliente where Direccion is not null) > 0
	Begin
		insert into Address (IdAddressType,IdPerson,Address,RegisterDate,RegisterUser)
		values(
			(select id from AddressType where lower(description) = 'oficina'),
			@IdPerson,
			(select Direccion from @tCliente),
			getdate(),
			dbo.fn_mgr_user()
		)
	End

	-- Guardo el telefono del cliente, manejando las cadenas del origen que solo describen los rangos.
	if (select count(1) from @tCliente where Telefono is not null) > 0
	Begin
		set @Telefono = (select lower(telefono) from @tCliente)

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
	if (select count(1) from @tCliente where Fax is not null) > 0
	Begin
		set @Telefono = (select lower(fax) from @tCliente)

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
		INSERT INTO Customer (IdPerson, LegalRepresentative, PersonCode, ImporterCode, ExporterCode,
							BondEndDate, RegisterDate, RegisterUser)
		VALUES(
				@IdPerson,
				(select Representante_Legal from @tCliente),
				(select Codigo_Cliente from @tCliente),
				(select Codigo_Importador_Exportador from @tCliente),
				(select Codigo_Importador_Exportador from @tCliente),
				(select Fecha_Vencimiento from @tCliente),
				getdate(),
				dbo.fn_mgr_user()
			);
	End
	--Inserto al cliente en su cuenta respectiva
	--if not exists (select 1 from Account where lower(Name) like '%local%')
	--	insert into CustomerType (name) values('Local')

	IF @Constancia = 1 
	Begin
		if not exists (select 1 from Account where lower(Name) like '%constancia%')
		begin
			insert into Account (Name,Description,RegisterDate,RegisterUser)
				values(
					'Constancias',
					'Registro para el control de la cuenta CONSTANCIAS',
					getdate(),
					dbo.fn_mgr_user()
				)
				Print 'Inserto en tabla account la constancia'
		end
	End
	ELSE
	Begin
		if not exists (select 1 from Account where lower(Name) like '%29%89%')
		begin
			insert into Account (Name,Description,RegisterDate,RegisterUser)
				values(
					'Cta Cte 29 89',
					'Registro para el control de la cuenta corriente 29 89',
					getdate(),
					dbo.fn_mgr_user()
				)
				Print 'Inserto en tabla account la cuenta corriente 2989'
		end
	End

	IF @Constancia = 1
	Begin
		if (select count(1)
			from CustomerAccount ca
			where ca.IdCustomer = @IdPerson
				and ca.IdAccount in (select id from Account where lower(name) like '%constancia%')
		) = 0
		Begin
			set @IdAccnt = (select id from Account where lower(name) like '%constancia%')

			INSERT INTO CustomerAccount (IdCustomer, IdAccount, ResolutionRate, RegimeRate, Resolutionstartdate,ResolutionEndDate,
											FiscalPeriodStartDate, FiscalPeriodEndDate, RegisterDate, RegisterUser)
			VALUES(
					@IdPerson,
					@IdAccnt,
					(select Resolucion_Calificacion from @tCliente),
					(select Regimen_Calificacion from @tCliente),
					(select Fecha_Resolucion from @tCliente),
					(select Fecha_Vencimiento from @tCliente),
					Null,NULL,
					getdate(),
					dbo.fn_mgr_user()
				)
				
				Print 'Inserto en tabla customer account '+ ltrim(rtrim(str(@IdAccnt))) +' para constancia para el cliente ' + ltrim(rtrim(str(@IdPerson)))
		End
	End
	ELSE
	Begin
		if (select count(1)
			from CustomerAccount ca
			where ca.IdCustomer = @IdPerson
				and ca.IdAccount in (select id from Account where lower(name) like '%29%89%')
		) = 0
		Begin
			set @IdAccnt = (select id from Account where lower(name) like '%29%89%')

			INSERT INTO CustomerAccount (IdCustomer, IdAccount, ResolutionRate, RegimeRate, Resolutionstartdate,ResolutionEndDate,
											FiscalPeriodStartDate, FiscalPeriodEndDate, RegisterDate, RegisterUser)
			VALUES(
					@IdPerson,
					@IdAccnt,
					(select Resolucion_Calificacion from @tCliente),
					(select Regimen_Calificacion from @tCliente),
					(select Fecha_Resolucion from @tCliente),
					(select Fecha_Vencimiento from @tCliente),
					Null,NULL,
					getdate(),
					dbo.fn_mgr_user()
				)
				Print 'Inserto en tabla customer account '+ ltrim(rtrim(str(@IdAccnt))) +' para cta cte 2989 para el cliente ' + ltrim(rtrim(str(@IdPerson)))
		End
	End

	SET @IdPersonOut = @IdPerson;
	SET @IdAccntOut = @IdAccnt;

End Try
Begin Catch
	IF (XACT_STATE() = -1)
	BEGIN  
		PRINT  
			N'sp_mgr_crear_cliente --> The transaction is in an uncommittable state.' +  
			N'sp_mgr_crear_cliente --> Rolling back transaction.'  
		ROLLBACK TRANSACTION;
		Begin Transaction;
	END;  
  
	-- Test whether the transaction is committable.  
	IF (XACT_STATE() = 1)
	BEGIN  
		PRINT  
			N'sp_mgr_crear_cliente --> The transaction is committable.' +  
			N'sp_mgr_crear_cliente --> Committing transaction.'  
		COMMIT TRANSACTION;     
		Begin Transaction;
	END;
	set @Mensaje =  ERROR_MESSAGE();
	exec dbo.sp_mgr_crear_error @Mensaje, @IdCliente, 1, @Id_Error output;

	SET @IdPersonOut = NULL;
	SET @IdAccntOut = NULL;

	commit transaction;
End Catch
END;