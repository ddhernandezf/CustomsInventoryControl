CREATE PROCEDURE [dbo].[sp_mgr_cargar_transaccion]
	@Result numeric(6,0) output
AS
BEGIN
	Declare	@Mensaje		nvarchar(max),
			@Id_Error		INT;

	SET XACT_ABORT ON;

	Begin Try
		Begin transaction;
			delete tbl_mgr_transaccion
		commit tran;

		Begin transaction;
			INSERT INTO TBL_MGR_TRANSACCION (Id_Transaccion, Import_Export, Linea, Id_Documento, Id_MP, Cantidad, CIF_Q, CIF_D, FOB_Q, FOB_D, DAI, IVA, Fecha_Sistema)
			select di.Id_Detalle_Importacion Id_Transaccion, 0 Imp_Exp, di.Linea_Importacion Linea, di.Id_Cabecera_Importacion Id_Documento, di.Id_Materia_Prima Id_MP,
					di.Cantidad, di.Costo_Cif_Quetzales CIF_Q, di.Costo_Cif_Dolares CIF_D, di.Costo_Fob_Quetzales FOB_Q, di.Costo_Fob_Dolares FOB_D, di.Derechos_Suspenso DAI,
					di.Iva_Suspenso IVA, di.Fecha_Sistema
			from DBIndexIE..Detalle_Importacion di
			where exists (select 1
						from tbl_mgr_documento tmd
						where tmd.Id_Documento = di.Id_Cabecera_Importacion
							and tmd.IdFileHeader is not null)
				and di.Estado <> 'A'
			Union ALL
			select de.Id_Detalle_Exportacion Id_Transaccion, 1 Imp_Exp, de.Linea_Exportacion Linea, de.Id_Cabecera_Exportacion Id_Documento, de.Id_Producto Id_MP,
					de.Cantidad, de.Costo_Cif_Quetzales CIF_Q, de.Costo_Cif_Dolares CIF_D, de.Costo_Fob_Quetzales FOB_Q, de.Costo_Fob_Dolares FOB_D, de.Suspenso DAI,
					de.Iva, de.Fecha_Sistema
			from DBIndexIE..Detalle_Exportacion de
			where exists (select 1
						from tbl_mgr_documento tmd
						where tmd.Id_Documento = de.Id_Cabecera_Exportacion
							and tmd.IdFileHeader is not null)
				and de.Estado <> 'A'		

			set @Result = @@ROWCOUNT;
		commit transaction;

	End Try
	Begin Catch
		IF (XACT_STATE() = -1)
		BEGIN  
			PRINT  
				N'sp_mgr_cargar_transaccion --> The transaction is in an uncommittable state.' +  
				N'sp_mgr_cargar_transaccion --> Rolling back transaction.'  
			ROLLBACK TRANSACTION;
			Begin Transaction;
		END;  
  
		-- Test whether the transaction is committable.  
		IF (XACT_STATE() = 1)
		BEGIN  
			PRINT  
				N'sp_mgr_cargar_transaccion --> The transaction is committable.' +  
				N'sp_mgr_cargar_transaccion --> Committing transaction.'  
			COMMIT TRANSACTION;     
			Begin Transaction;
		END;
		set @Mensaje =  'Error insertando transacciones para migracion en tabla temporal';
		exec dbo.sp_mgr_crear_error @Mensaje, 0, 1, @Id_Error output;
		commit transaction;
	End Catch

--******************* INSERT TRANSACCIONES DE IMPORTACION ***********************************************************
	Begin tran;
		INSERT INTO [FileDetail] (IdFileHeader, IdState, TransactionLine, IdItem, ItemQuantity,
									CIFCotQuetzal, FOCostQuetzal, CIFCotDollar, FOCostDollar,
									CustomDuties, Iva, RegisterDate, RegisterUser)
		select tmd.IdFileHeader, (SELECT Id FROM [State] WHERE [Name] = 'Grabado'), tmt.Linea, tmmp.IdItem, 
			tmt.Cantidad, tmt.CIF_Q, tmt.FOB_Q,	tmt.CIF_D, tmt.FOB_D, tmt.DAI, tmt.IVA, tmt.Fecha_Sistema, dbo.fn_mgr_user()
		from tbl_mgr_transaccion tmt
			INNER JOIN tbl_mgr_documento tmd ON tmd.Id_Documento = tmt.Id_Documento
				AND tmd.Import_Export = tmt.Import_Export
			INNER JOIN tbl_mgr_materia_producto tmmp ON tmmp.id_Materia_Producto = tmt.Id_MP
				AND tmmp.Producto = tmt.Import_Export
		where tmt.Import_Export = 0
			--and exists (SELECT 1
			--		FROM DBIndexIE..Relacion_Detalle rdi
			--		where rdi.Id_Detalle_Importacion = tmt.Id_Transaccion
			--			and rdi.Estado <> 'A')
		set @Result = @@ROWCOUNT;
	commit transaction;
	Print N' INSERT Cantidad transacciones de importacion en nueva estructura FILEDETAIL:' + str(@Result)

	Begin transaction;
		UPDATE TBL_MGR_TRANSACCION
			SET IdFileDetail = fd.Id,
				IdFileHeader = tmd.IdFileHeader, 
				IdItem = tmmp.IdItem, 
				fecha_proceso = getdate() 
		from tbl_mgr_transaccion tmt
			INNER JOIN tbl_mgr_documento tmd ON tmd.Id_Documento = tmt.Id_Documento
				AND tmd.Import_Export = tmt.Import_Export
			INNER JOIN tbl_mgr_materia_producto tmmp ON tmmp.id_Materia_Producto = tmt.Id_MP
				AND tmmp.Producto = tmt.Import_Export
			INNER JOIN FileDetail fd ON fd.IdFileHeader = tmd.IdFileHeader
				AND fd.TransactionLine = tmt.Linea
				AND fd.IdItem = tmmp.IdItem
				AND fd.ItemQuantity = tmt.Cantidad
		where tmt.Import_Export = 0
			--and exists (SELECT 1
			--		FROM DBIndexIE..Relacion_Detalle rdi
			--		where rdi.Id_Detalle_Importacion = tmt.Id_Transaccion
			--			and rdi.Estado <> 'A')
		set @Result = @@ROWCOUNT;
	commit transaction;
	Print N' UPDATE cantidad transacciones de importacion actualizadas tabla temporal' + str(@Result)

	Begin Transaction;
		INSERT INTO [ItemInventory](IdCustomer, IdAccount, IdFileHeader, IdFileDetail, IdItem, Quantity,
									Stock, CIFcost, FOcost, CustomDuties, Iva, TransactionDate, IdState) 
		select tmc.id_person, tmc.id_Account, tmd.IdFileHeader, tmt.IdFileDetail, tmt.IdItem, tmt.Cantidad,
			tmt.Cantidad, tmt.CIF_Q, tmt.FOB_Q, tmt.DAI, tmt.IVA, tmt.Fecha_Sistema, 1
		from tbl_mgr_transaccion tmt
			INNER JOIN tbl_mgr_documento tmd ON tmd.Id_Documento = tmt.Id_Documento
				AND tmd.Import_Export = tmt.Import_Export
			INNER JOIN tbl_mgr_cliente tmc ON tmc.id_cliente = tmd.id_Cliente
			INNER JOIN tbl_mgr_materia_producto tmmp ON tmmp.id_Materia_Producto = tmt.Id_MP
				AND tmmp.Producto = tmt.Import_Export
		where tmt.Import_Export = 0
			--and exists (SELECT 1
			--		FROM DBIndexIE..Relacion_Detalle rdi
			--		where rdi.Id_Detalle_Importacion = tmt.Id_Transaccion
			--			and rdi.Estado <> 'A')

		set @Result = @@ROWCOUNT;
	commit transaction;
	Print N' INSERT transacciones de importacion en nueva estructura ITEMINVENTORY:' + str(@Result)
	
--******************* INSERT TRANSACCIONES DE EXPORTACION ***********************************************************
	Begin transaction;
		INSERT INTO [FileDetail] (IdFileHeader, IdState, TransactionLine, IdItem, ItemQuantity,
									CIFCotQuetzal, FOCostQuetzal, CIFCotDollar, FOCostDollar,
									CustomDuties, Iva, RegisterDate, RegisterUser)
		select tmd.IdFileHeader, (SELECT Id FROM [State] WHERE [Name] = 'Grabado'), tmt.Linea, tmmp.IdItem, 
			tmt.Cantidad, tmt.CIF_Q, tmt.FOB_Q,	tmt.CIF_D, tmt.FOB_D, tmt.DAI, tmt.IVA, tmt.Fecha_Sistema, dbo.fn_mgr_user()
		from tbl_mgr_transaccion tmt
			INNER JOIN tbl_mgr_documento tmd ON tmd.Id_Documento = tmt.Id_Documento
				AND tmd.Import_Export = tmt.Import_Export
			INNER JOIN tbl_mgr_materia_producto tmmp ON tmmp.id_Materia_Producto = tmt.Id_MP
				AND tmmp.Producto = tmt.Import_Export
		where tmt.Import_Export = 1
			--and exists (SELECT 1
			--		FROM DBIndexIE..Relacion_Detalle rdi
			--		where rdi.Id_Detalle_Exportacion = tmt.Id_Transaccion
			--			and rdi.Estado <> 'A')
			set @Result = @@ROWCOUNT;
	commit transaction;
	Print N' INSERT Cantidad transacciones de exportacion en nueva estructura FILEDETAIL:' + str(@Result)

	Begin transaction;
		UPDATE TBL_MGR_TRANSACCION
			SET IdFileDetail = fd.Id,
				IdFileHeader = tmd.IdFileHeader, 
				IdItem = tmmp.IdItem, 
				fecha_proceso = getdate() 
		from tbl_mgr_transaccion tmt
			INNER JOIN tbl_mgr_documento tmd ON tmd.Id_Documento = tmt.Id_Documento
				AND tmd.Import_Export = tmt.Import_Export
			INNER JOIN tbl_mgr_materia_producto tmmp ON tmmp.id_Materia_Producto = tmt.Id_MP
				AND tmmp.Producto = tmt.Import_Export
			INNER JOIN FileDetail fd ON fd.IdFileHeader = tmd.IdFileHeader
				AND fd.TransactionLine = tmt.Linea
				AND fd.IdItem = tmmp.IdItem
				AND fd.ItemQuantity = tmt.Cantidad
				AND fd.CIFCotQuetzal = tmt.CIF_Q
		where tmt.Import_Export = 1
			--and exists (SELECT 1
			--		FROM DBIndexIE..Relacion_Detalle rdi
			--		where rdi.Id_Detalle_Exportacion = tmt.Id_Transaccion
			--			and rdi.Estado <> 'A')
		set @Result = @@ROWCOUNT;
	commit transaction;
	Print N' UPDATE cantidad transacciones de exportacion actualizadas tabla temporal' + str(@Result)

	set @Result = 1;
END;