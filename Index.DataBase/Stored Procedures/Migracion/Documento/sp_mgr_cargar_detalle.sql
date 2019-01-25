CREATE PROCEDURE [dbo].[sp_mgr_cargar_detalle]
	@Result numeric(18,0) output
AS
BEGIN
	Declare	@Mensaje		nvarchar(max),
			@Id_Error		INT;

	SET XACT_ABORT ON;

	Begin Try
		Begin transaction;
			delete tbl_mgr_transaccion_detalle
		commit transaction;

		Begin transaction;
			INSERT INTO TBL_MGR_TRANSACCION_DETALLE (Id_Detalle, Id_Detalle_I, Id_Detalle_E, Cantidad, Cantidad_Merma, CIF_Q, FOB_Q, DAI, IVA, Fecha_Sistema)
			select rd.Id_Relacion_Detalle, rd.Id_Detalle_Importacion, rd.Id_Detalle_Exportacion, rd.Cantidad, rd.Cantidad_Merma, rd.Costo_Cif, rd.Costo_Fob, rd.Suspenso, rd.Iva,
					rd.Fecha_Sistema
			from DBIndexIE..Relacion_Detalle rd
			where rd.Estado <> 'A'
				--and rd.Id_Detalle_Exportacion NOT in(select Id_Detalle_Exportacion 
				--						from DBIndexIE..Detalle_Exportacion de
				--						where de.Estado = 'A'
				--							and exists(select 1
				--									from DBIndexIE..Relacion_Detalle rd
				--									where rd.Id_Detalle_Exportacion = de.Id_Detalle_Exportacion
				--										and rd.Estado <> 'A'))

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

	Begin transaction;
		INSERT INTO FileItemDischarge(IdFileDetailSubstract, IdFileDetailStock, IdState,Quantity, Decrease, CIFcost, FOcost,
										CustomDuties, Iva, RegisterDate, RegisterUser)
		select tmte.IdFileDetail, tmti.IdFileDetail, 1, tmtd.Cantidad, tmtd.Cantidad_Merma, tmtd.CIF_Q, tmtd.FOB_Q,
			tmtd.DAI, tmtd.IVA, tmtd.Fecha_Sistema, dbo.fn_mgr_user()
		--select tmte.IdFileDetail, tmti.IdFileDetail, 1, sum(tmtd.Cantidad), sum(tmtd.Cantidad_Merma), sum(tmtd.CIF_Q), sum(tmtd.FOB_Q),
		--	sum(tmtd.DAI), sum(tmtd.IVA), max(tmtd.Fecha_Sistema), dbo.fn_mgr_user()
		from tbl_mgr_transaccion_detalle tmtd
			INNER JOIN tbl_mgr_transaccion tmti
				ON tmti.Id_Transaccion = tmtd.Id_Detalle_I
			INNER JOIN tbl_mgr_transaccion tmte
				ON tmte.Id_Transaccion = tmtd.Id_Detalle_E
		where tmti.IdFileDetail is not null
			and tmte.IdFileDetail is not null
		--group by tmte.IdFileDetail, tmti.IdFileDetail

		set @Result = @@ROWCOUNT;
	commit transaction;
	Print N' INSERT Cantidad de descargos ' + str(@Result)

	Begin Tran;
		UPDATE TBL_MGR_TRANSACCION_DETALLE
			SET IdFileItemD = fid.Id,
				IdFileDStock = tmti.IdFileDetail, 
				IdFileDSubst = tmte.IdFileDetail, 
				fecha_proceso = getdate() 
		from tbl_mgr_transaccion_detalle tmtd
			INNER JOIN tbl_mgr_transaccion tmti
				ON tmti.Id_Transaccion = tmtd.Id_Detalle_I
			INNER JOIN tbl_mgr_transaccion tmte
				ON tmte.Id_Transaccion = tmtd.Id_Detalle_E
			INNER JOIN FileItemDischarge fid
				ON fid.IdFileDetailStock = tmti.IdFileDetail
					AND FID.IdFileDetailSubstract = tmte.IdFileDetail
		where tmti.IdFileDetail is not null
			and tmte.IdFileDetail is not null

		set @Result = @@ROWCOUNT;
	commit tran;
	Print N' UPDATE Cantidad de descargos en tabla temporal' + str(@Result)

	Begin tran;
		UPDATE ItemInventory 
			SET	Stock = (ii.Stock - td.Cantidad),
				CIFcost = (ii.CIFcost - td.CIF_Q),
				FOcost = (ii.FOcost - td.FOB_Q),
				CustomDuties = (ii.CustomDuties - td.DAI),
				Iva = (ii.Iva - td.iva)
		FROM ItemInventory ii 
			INNER JOIN (select tmtd.IdFileDStock, sum(tmtd.Cantidad + tmtd.Cantidad_Merma) Cantidad, 
							sum(tmtd.CIF_Q) CIF_Q, sum(tmtd.FOB_Q) FOB_Q, sum(tmtd.DAI) DAI, sum(tmtd.IVA) IVA
					from tbl_mgr_transaccion_detalle tmtd
					where tmtd.IdFileItemD is not null
					group by tmtd.IdFileDStock) td
				ON td.IdFileDStock = ii.IdFileDetail

		set @Result = @@ROWCOUNT;
	commit tran;
	Print N' UPDATE Item Inventory' + str(@Result)
END;