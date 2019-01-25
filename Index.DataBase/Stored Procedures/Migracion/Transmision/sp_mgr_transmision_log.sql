CREATE PROCEDURE [dbo].[sp_mgr_transmision_log]
	@Result numeric(18,0) output
AS
BEGIN
	Declare	@Mensaje		nvarchar(max),
			@Id_Error		INT;
	Declare @IdState		INT;
	Declare @CNS_Estado		varchar(10) = 'Ingresado';
	declare @T_Documento table(
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
			delete tbl_mgr_transmision_log
		commit tran;

		Begin transaction;
			INSERT INTO TBL_MGR_TRANSMISION_LOG (Id_Log_Transmision, Id_Transmision, Id_Relacion_Detalle, Fecha_Carga, Codigo_Envio, Fecha_Envio, Tipo_Envio, Tipo_Cuenta,Exportador,
												Nit, Poliza_Importacion, Linea_Importacion, Cantidad, CIF, DAI, IVA, Poliza_Exportacion, Linea_Exportacion, Tipo_Error, Mensaje_Error,
												Numero_Operacion, CIF_OPA, DAI_OPA, IVA_OPA, Multa_Nacionalizacion, Monto_Multa_Nacionalizacion, Multa_Extemporanea, Monto_Multa_Extemporanea)
			select * 
			from DBIndexIE..Log_Transmision lt
			where exists (select 1 
						from DBIndexIE..Relacion_Detalle rd
						where rd.Id_Relacion_Detalle = lt.Id_Relacion_Detalle
							and rd.Estado <> 'A')		
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
		set @Mensaje =  'Error insertando cabeceras de lotes transmitidos a OPA ONLINE para migracion en tabla temporal';
		exec dbo.sp_mgr_crear_error @Mensaje, 0, 1, @Id_Error output;
		commit transaction;
	End Catch

	select @IdState = Id 
	from [state] where name = 'Transmitido'

	begin tran;
		INSERT INTO OpaDetail (IdOpaHeader, IdState, IdFileItemDischarge, IdFileHeaderSubstract, IdFileDetailSubstract, IdDocumentSubstract, TransactionLineSubstract,
									QuantitySubstract, CifSubstract, FobSubstract, CustomDutiesSubstract, IvaSubstract, IdFileHeaderStock, IdFileDetailStock, IdDocumentStock,
									TransactionLineStock, StartDate, EndDate)
		select tmt.IdOpaHeader, @IdState, tmtd.IdFileItemD, tmde.IdFileHeader, tmte.IdFileDetail, tmde.Poliza_Numero, tmte.Linea, tmtl.Cantidad, tmtl.cif, tmtd.FOB_Q, tmtl.dai, tmtl.iva,
			tmdi.IdFileHeader, tmti.IdFileDetail, tmdi.Poliza_Numero, tmti.Linea, tmt.Fecha_Inicial, tmt.Fecha_Final
		--select *
		from tbl_mgr_transmision_log tmtl
			INNER JOIN tbl_mgr_transmision tmt ON tmt.Id_Transmision = tmtl.Id_Transmision
			INNER JOIN tbl_mgr_transaccion_detalle tmtd ON  tmtd.Id_Detalle = tmtl.Id_Relacion_Detalle
			INNER JOIN tbl_mgr_transaccion tmte ON tmte.Id_Transaccion = tmtd.Id_Detalle_E
												AND tmte.Import_Export = 1			
			INNER JOIN tbl_mgr_documento tmde ON tmde.Id_Documento = tmte.Id_Documento
												AND tmde.Import_Export = 1
			INNER JOIN tbl_mgr_transaccion tmti ON tmti.Id_Transaccion = tmtd.Id_Detalle_I
												AND tmti.Import_Export = 0
			INNER JOIN tbl_mgr_documento tmdi ON tmdi.Id_Documento = tmti.Id_Documento
												AND tmdi.Import_Export = 0
		WHERE tmtd.IdFileItemD IS NOT NULL
			and tmtl.Numero_Operacion > 0
			and tmt.IdOpaHeader IS NOT NULL
	commit tran;

	begin tran;
		SET IDENTITY_INSERT [OpaDetailHist] ON;
		INSERT INTO [OpaDetailHist](Id, IdOpaHeader, IdState, IdFileItemDischarge, IdFileHeaderSubstract, IdFileDetailSubstract,
						IdDocumentSubstract, TransactionLineSubstract, QuantitySubstract, CifSubstract, FobSubstract,
						CustomDutiesSubstract, IvaSubstract, IdFileHeaderStock, IdFileDetailStock, IdDocumentStock,
						TransactionLineStock, StartDate, EndDate)
		SELECT	Id, IdOpaHeader, IdState, IdFileItemDischarge, IdFileHeaderSubstract, IdFileDetailSubstract,
						IdDocumentSubstract, TransactionLineSubstract, QuantitySubstract, CifSubstract, FobSubstract,
						CustomDutiesSubstract, IvaSubstract, IdFileHeaderStock, IdFileDetailStock, IdDocumentStock,
						TransactionLineStock, StartDate, EndDate
		  FROM	[OpaDetail]
		SET IDENTITY_INSERT [OpaDetailHist] OFF;
	commit tran;

	begin tran;
		DELETE FROM [OpaDetail]
	commit tran;

	begin tran;
		UPDATE TBL_MGR_TRANSMISION_LOG
			SET IdOpaHeader = odh.IdOpaHeader,
				IdOpaDetail = odh.Id,
				IdFileItemDischarge = tmtd.IdFileItemD
		--select * from tbl_mgr_transaccion_detalle
		--select * 
		from tbl_mgr_transmision_log tmtl
			INNER JOIN tbl_mgr_transmision tmt ON tmt.Id_Transmision = tmtl.Id_Transmision
			INNER JOIN tbl_mgr_transaccion_detalle tmtd ON  tmtd.Id_Detalle = tmtl.Id_Relacion_Detalle
			INNER JOIN tbl_mgr_transaccion tmte ON tmte.Id_Transaccion = tmtd.Id_Detalle_E
												AND tmte.Import_Export = 1			
			INNER JOIN tbl_mgr_documento tmde ON tmde.Id_Documento = tmte.Id_Documento
												AND tmde.Import_Export = 1
			INNER JOIN tbl_mgr_transaccion tmti ON tmti.Id_Transaccion = tmtd.Id_Detalle_I
												AND tmti.Import_Export = 0
			INNER JOIN tbl_mgr_documento tmdi ON tmdi.Id_Documento = tmti.Id_Documento
												AND tmdi.Import_Export = 0
			INNER JOIN OpaDetailHist odh ON odh.IdFileItemDischarge = tmtd.IdFileItemD
											AND odh.IdFileDetailSubstract = tmte.IdFileDetail
											AND odh.TransactionLineSubstract = tmte.Linea
											AND odh.IdFileHeaderSubstract = tmte.IdFileHeader
											AND odh.IdDocumentSubstract = tmde.Poliza_Numero
											AND odh.IdFileDetailStock = tmti.IdFileDetail
											AND odh.TransactionLineStock = tmti.Linea
											AND odh.IdFileHeaderStock = tmti.IdFileHeader
											AND odh.IdDocumentStock = tmdi.Poliza_Numero
											AND odh.IdOpaHeader = tmt.IdOpaHeader
		WHERE tmtd.IdFileItemD IS NOT NULL
			and tmt.IdOpaHeader IS NOT NULL
			and tmtl.Numero_Operacion > 0
	commit tran;

	begin tran;
		INSERT INTO OpaResponseHist (IdOpaDetail, TransactionNumber, ErrorType, ErrorMessage, Cif, CustomDuties, Iva, NationalizationMulct, NationalizationMulctAmmount,
								ExtemporaneusMulct, ExtemporaneusMulctAmmount, ResponseDate)
		select tmtl.IdOpaDetail, tmtl.Numero_Operacion, tmtl.Tipo_Error, tmtl.Mensaje_Error, tmtl.Cif_Opa, tmtl.Dai_Opa, tmtl.Iva_Opa, tmtl.Multa_Nacionalizacion,
			tmtl.Monto_Multa_Nacionalizacion, tmtl.Multa_Extemporanea, tmtl.Monto_Multa_Extemporanea, tmtl.Fecha_Envio
		from tbl_mgr_transmision_log tmtl where IdOpaDetail is not null
	commit tran;
END;