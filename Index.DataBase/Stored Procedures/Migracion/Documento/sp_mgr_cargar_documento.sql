CREATE PROCEDURE [dbo].[sp_mgr_cargar_documento]
	@Result numeric(6,0) output
AS
BEGIN
	Declare	@Mensaje		nvarchar(max),
			@Id_Error		INT;
	Declare @CNS_Estado		varchar(10) = 'Ingresado';
	declare @T_Documento table(
		Id_Account			INT NOT NULL,
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
			delete tbl_mgr_documento
		commit tran;

		Begin transaction;
		Insert INTO TBL_MGR_DOCUMENTO (Id_Documento, Import_Export, Id_Cliente, Id_Aduana, Id_Pais, Id_Proveedor, Id_Garantia, Id_Moneda, Poliza_Numero, Factura_No,
					Tipo_Cambio, Seguro, Flete, Id_Tipo_Documento, Fecha_Documento, Fecha_Vencimiento, Fecha_Sistema, Fecha_Ampliacion)
		select ci.Id_Cabecera_Importacion Id_Documento, 0 Imp_Exp, ci.Id_Cliente, ci.Id_Aduana, ci.Id_Pais, ci.Id_Proveedor, ci.Id_Garantia, ci.Id_Moneda,
			ci.Poliza_Importacion Poliza, ci.Numero_Factura Factura, ci.Tipo_Cambio, ci.Seguro, ci.Flete, ci.Id_Documento Tipo_Documento, 
			ci.Fecha_Autorizacion FD, ci.Fecha_Vencimiento FV, ci.Fecha_Sistema FS, ci.Fecha_Ampliacion FA
		from DBIndexIE..Cabecera_Importacion ci
		where exists (select 1 
					from tbl_mgr_cliente tmc 
					where tmc.id_cliente = ci.Id_Cliente
						and tmc.id_person is not null)
			and ci.estado <> 'A'
		Union all
		select ce.Id_Cabecera_Exportacion Id_Documento, 1 Imp_Exp, ce.Id_Cliente, ce.Id_Aduana, ce.Id_Pais, ce.Id_Proveedor, Null Id_Garantia, Null Id_Moneda,
			ce.Poliza_Exportacion Poliza, ce.Numero_Factura Factura, NULL Tipo_Cambio, Null Seguro, Null Flete, ce.Id_Documento Tipo_Documento, 
			ce.Fecha_Documento FD, ce.Fecha_Factura FV, ce.Fecha_Sistema FS, Null FA
		from DBIndexIE..Cabecera_Exportacion ce
		where exists (select 1 
					from tbl_mgr_cliente tmc 
					where tmc.id_cliente = ce.Id_Cliente
						and tmc.id_person is not null)
			and ce.estado <> 'A'
		
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
		set @Mensaje =  'Error insertando documentos para migracion en tabla temporal';
		exec dbo.sp_mgr_crear_error @Mensaje, 0, 1, @Id_Error output;
		commit transaction;
	End Catch

--  Actualizamos polizas de exportacion duplicadas 
	set @Mensaje =  'Polizas de exportacion duplicadas';
	exec dbo.sp_mgr_crear_error @Mensaje, 0, 1, @Id_Error output;

	Begin Tran;
		update tbl_mgr_documento
			set Poliza_Numero = Poliza_Numero + '-' + ltrim(rtrim(str(id_documento))),
				id_error = @Id_Error
		where exists (select 1
					from tbl_mgr_documento tmd 
					where tmd.Import_Export = tbl_mgr_documento.Import_Export
						and tmd.id_Cliente = tbl_mgr_documento.id_Cliente
						and tmd.Poliza_Numero = tbl_mgr_documento.Poliza_Numero
						and exists(select 1
								from DBIndexIE..Detalle_Exportacion di
								where di.Id_Cabecera_Exportacion = tmd.Id_Documento
									and di.Estado <> 'A')
					group by tmd.Import_Export, tmd.id_Cliente, tmd.Id_Tipo_Documento, tmd.Poliza_Numero
					having count(1) > 1)
	commit tran;

	-- Inserto los tipos de documento
	INSERT INTO @T_Documento (Id_Account, Id_Tipo_Documento, IdFileInfoConfig, Imp_Exp)
		select tdoc_old.id_Account, tdoc_old.Id_Documento, --tdoc_old.Descripcion,
			case when tdoc_new.Id is null then 
				(select fic.Id --fi.Name, fit.Name, fic.IsSubstract
				from FileInfoType fit
					INNER JOIN FileInfoConfig fic ON fic.IdFileType = fit.Id
					INNER JOIN FileInfo fi ON fic.IdFileInfo = fi.Id
				where fic.IsSubstract = tdoc_old.Import_Export
					and lower(replace(fi.Name,'ó','o')) = case when tdoc_old.id_Account = 1 
																then 'poliza'
																else
																	case when tdoc_old.Import_Export = 1
																		then 'poliza'
																		else 'factura'
																		end
																end
					AND fic.IdAccount = tdoc_old.id_Account)
			else tdoc_new.Id end, tdoc_old.Import_Export
		from (select do.Id_Documento, do.Descripcion, tmd.Import_Export, tmc.id_Account,
				replace(replace(lower(rtrim(ltrim(do.Descripcion))),'de',''),' ','%') J_Descript
				from DBIndexIE..Documento do, tbl_mgr_documento tmd, tbl_mgr_cliente tmc
				where do.Id_Documento = tmd.Id_Tipo_Documento
					and tmc.id_cliente = tmd.id_Cliente
				Group by do.Id_Documento, do.Descripcion, tmd.Import_Export, tmc.id_Account) tdoc_old
			LEFT JOIN
				(select fic.IdAccount, fic.Id, fi.Name fi_name, fit.Name fit_name, fic.IsSubstract, lower(replace(fi.Name,'ó','o') + replace(fit.Name,'ó','o')) J_Name,
				lower(replace(IsNull(fi.Description,''),'ó','o') + replace(IsNull(fit.Description,''),'ó','o')) J_Descript
				from FileInfoType fit
					INNER JOIN FileInfoConfig fic ON fic.IdFileType = fit.Id
					INNER JOIN FileInfo fi ON fic.IdFileInfo = fi.Id) tdoc_new
			ON ((tdoc_new.J_Name COLLATE DATABASE_DEFAULT like '%' + tdoc_old.J_Descript + '%')
				OR (tdoc_new.J_Descript COLLATE DATABASE_DEFAULT like '%' + tdoc_old.J_Descript+ '%'))
				and tdoc_new.IsSubstract = tdoc_old.Import_Export
				and tdoc_new.IdAccount = tdoc_old.id_Account
		ORDER BY tdoc_old.id_Account, tdoc_old.Import_Export

		INSERT INTO @T_Moneda (Id_Moneda, IdCurrency)
		select mo.Id_Moneda, cu.Id
		from DBIndexIE..Moneda mo 
			INNER JOIN Currency cu 
			ON cu.Name COLLATE DATABASE_DEFAULT like '%' + mo.Nombre + '%'

		--- Inserto IMPORTACIONES
		Begin tran;
			INSERT INTO FileHeader (IdCustomer, IdAccount, IdFileInfoConfig, IdDocument, AuthorizationDate, ExpantionDate, ExpirationDate, DocumentDate, ArrivalDate,
									ExchangeRate, Insurance, Cargo, IdCustom, IdCountry, IdWarranty, IdState, IdCurrency, RegisterDate,RegisterUser,CreateDate)
			select tmc.id_person, tmc.id_Account, td.IdFileInfoConfig, tmd.Poliza_Numero, tmd.Fecha_Documento, tmd.Fecha_Ampliacion, tmd.Fecha_Vencimiento,
				tmd.Fecha_Documento, tmd.Fecha_Documento, tmd.Tipo_Cambio, tmd.Seguro, tmd.Flete, tma.id_custom, tmp.IdCountry, tmg.IdWarranty,
				(select Id from state where name = @CNS_Estado), tm.IdCurrency, tmd.Fecha_Sistema, dbo.fn_mgr_user(), tmd.Fecha_Sistema
			from tbl_mgr_documento tmd
					INNER JOIN tbl_mgr_cliente tmc ON tmc.id_cliente = tmd.id_cliente
					INNER JOIN @T_Documento td ON td.Id_Tipo_Documento = tmd.Id_Tipo_Documento
											AND td.Imp_Exp = tmd.Import_Export
											and td.Id_Account = tmc.id_Account
					INNER JOIN tbl_mgr_aduana tma ON tma.id_aduana = tmd.Id_Aduana
					INNER JOIN tbl_mgr_pais tmp ON tmp.id_pais = tmd.Id_Pais
					LEFT JOIN tbl_mgr_garantia tmg ON tmg.id_garantia = tmd.Id_Garantia
					LEFT JOIN @T_Moneda tm	ON tm.Id_Moneda = tmd.Id_Moneda
			where Import_Export = 0
				--and tmd.id_cliente in(121)--(129, 168)
				and exists(select 1
						from DBIndexIE..Detalle_Importacion di
						where di.Id_Cabecera_Importacion = tmd.Id_Documento
							and di.Estado <> 'A')
				and not exists(select 1
							from FileHeader fh
							where fh.IdCustomer = tmc.id_person
							and fh.IdAccount = tmc.id_Account
							and fh.IdFileInfoConfig = td.IdFileInfoConfig
							and fh.IdDocument = tmd.Poliza_Numero)
		set @Result = @@ROWCOUNT;
		commit tran;
		PRINT N' Cantidad importaciones en tabla nueva estructura FILEHEADER: ' + str(@Result)

		--Actualizo la tabla temporal con los ids correspondientes				
		Begin Tran;
			UPDATE TBL_MGR_DOCUMENTO
				SET IdFileHeader = fh.Id, 
					IdPerson = tmc.id_person, 
					IdCustom = tma.id_custom,
					IdCountry = tmp.idCountry,
					IdWarranty =  tmg.idWarranty, 
					IdFileInfoConfig = td.IdFileInfoConfig,
					IdCurrency =  tm.IdCurrency, 
					fecha_proceso = getdate()
			FROM TBL_MGR_DOCUMENTO tmd
				LEFT JOIN tbl_mgr_garantia tmg ON tmg.id_garantia = tmd.Id_Garantia
				LEFT JOIN @T_Moneda tm ON tm.Id_Moneda = tmd.Id_Moneda,
				tbl_mgr_cliente tmc, @T_Documento td, tbl_mgr_aduana tma, tbl_mgr_pais tmp,
				FileHeader fh
			WHERE tmc.id_cliente = tmd.id_cliente
				AND td.Id_Tipo_Documento = tmd.Id_Tipo_Documento
				AND td.Imp_Exp = tmd.Import_Export
				AND tma.id_aduana = tmd.Id_Aduana
				AND tmp.id_pais = tmd.Id_Pais
				AND tmd.Import_Export = 0
				AND fh.IdCustomer = tmc.id_person
				AND fh.IdAccount = tmc.id_Account
				AND fh.IdFileInfoConfig = td.IdFileInfoConfig
				AND fh.IdDocument = tmd.Poliza_Numero
				AND exists(select 1
						from DBIndexIE..Detalle_Importacion di
						where di.Id_Cabecera_Importacion = tmd.Id_Documento
							and di.Estado <> 'A')

		set @Result = @@ROWCOUNT;
		commit tran;
		PRINT N' Cantidad IMPORTACIONES updates de ID nuevos en tabla temporal: ' + str(@Result)

		--- Inserto EXPORTACIONES
		Begin tran;
			INSERT INTO FileHeader (IdCustomer, IdAccount, IdFileInfoConfig, IdDocument, AuthorizationDate, ExpantionDate, ExpirationDate, DocumentDate, ArrivalDate,
									ExchangeRate, Insurance, Cargo, IdCustom, IdCountry, IdWarranty, IdState, IdCurrency, RegisterDate,RegisterUser,CreateDate)
			select tmc.id_person, tmc.id_Account, td.IdFileInfoConfig, tmd.Poliza_Numero, tmd.Fecha_Documento, tmd.Fecha_Ampliacion, tmd.Fecha_Vencimiento,
				tmd.Fecha_Documento, tmd.Fecha_Documento, tmd.Tipo_Cambio, tmd.Seguro, tmd.Flete, tma.id_custom, tmp.IdCountry, tmg.IdWarranty,
				(select Id from state where name = @CNS_Estado), tm.IdCurrency, getdate(), dbo.fn_mgr_user(), tmd.Fecha_Sistema
			from tbl_mgr_documento tmd
					INNER JOIN tbl_mgr_cliente tmc ON tmc.id_cliente = tmd.id_cliente
					INNER JOIN @T_Documento td ON td.Id_Tipo_Documento = tmd.Id_Tipo_Documento
											AND td.Imp_Exp = tmd.Import_Export
											and td.Id_Account = tmc.id_Account
					INNER JOIN tbl_mgr_aduana tma ON tma.id_aduana = tmd.Id_Aduana
					INNER JOIN tbl_mgr_pais tmp ON tmp.id_pais = tmd.Id_Pais
					LEFT JOIN tbl_mgr_garantia tmg ON tmg.id_garantia = tmd.Id_Garantia
					LEFT JOIN @T_Moneda tm	ON tm.Id_Moneda = tmd.Id_Moneda
			where tmd.Import_Export = 1
				--and tmd.id_cliente in(129, 168)
				and exists(select 1
						from DBIndexIE..Detalle_Exportacion de
						where de.Id_Cabecera_Exportacion = tmd.Id_Documento
							and de.Estado <> 'A')
				and not exists(select 1
							from FileHeader fh
							where fh.IdCustomer = tmc.id_person
							and fh.IdAccount = tmc.id_Account
							and fh.IdFileInfoConfig = td.IdFileInfoConfig
							and fh.IdDocument = tmd.Poliza_Numero)
		set @Result = @@ROWCOUNT;
		commit tran;
		PRINT N' Cantidad exportaciones en tabla nueva estructura FILEHEADER: ' + str(@Result)

		--Actualizo la tabla temporal con los ids correspondientes				
		Begin Tran;
			UPDATE TBL_MGR_DOCUMENTO
				SET IdFileHeader = fh.Id, 
					IdPerson = tmc.id_person, 
					IdCustom = tma.id_custom,
					IdCountry = tmp.idCountry,
					IdWarranty =  tmg.idWarranty, 
					IdFileInfoConfig = td.IdFileInfoConfig,
					IdCurrency =  tm.IdCurrency, 
					fecha_proceso = getdate()
			FROM TBL_MGR_DOCUMENTO tmd
				LEFT JOIN tbl_mgr_garantia tmg ON tmg.id_garantia = tmd.Id_Garantia
				LEFT JOIN @T_Moneda tm ON tm.Id_Moneda = tmd.Id_Moneda,
				tbl_mgr_cliente tmc, @T_Documento td, tbl_mgr_aduana tma, tbl_mgr_pais tmp,
				FileHeader fh
			WHERE tmc.id_cliente = tmd.id_cliente
				AND td.Id_Tipo_Documento = tmd.Id_Tipo_Documento
				AND td.Imp_Exp = tmd.Import_Export
				AND tma.id_aduana = tmd.Id_Aduana
				AND tmp.id_pais = tmd.Id_Pais
				AND tmd.Import_Export = 1
				AND fh.IdCustomer = tmc.id_person
				AND fh.IdAccount = tmc.id_Account
				AND fh.IdFileInfoConfig = td.IdFileInfoConfig
				AND fh.IdDocument = tmd.Poliza_Numero
				AND exists(select 1
						from DBIndexIE..Detalle_Exportacion de
						where de.Id_Cabecera_Exportacion = tmd.Id_Documento
							and de.Estado <> 'A')

		set @Result = @@ROWCOUNT;
		commit tran;
		PRINT N' Cantidad EXPORTACIONES updates de ID nuevos en tabla temporal: ' + str(@Result)

		Begin tran;
			INSERT INTO FileAttached (IdFileHeader, IdSupplier, AttachedNumber, AttachedDate, RegisterDate, RegisterUser)
			SELECT tmd.IdFileHeader, tmp.id_person, tmd.Factura_No, tmd.Fecha_Vencimiento, GETDATE(), dbo.fn_mgr_user()
			FROM tbl_mgr_documento tmd
				INNER JOIN tbl_mgr_proveedor tmp ON tmp.id_proveedor = tmd.Id_Proveedor
			WHERE tmd.IdFileHeader is not null
				and tmd.Factura_No is not null

			set @Result = @@ROWCOUNT;
		commit tran;
		PRINT N' Cantidad de documentos adjuntos : ' + str(@Result)

	set @Result = 1;
END;