CREATE PROCEDURE [dbo].[sp_mgr_correccion_datos]
	@Result numeric(6,0) output
AS
BEGIN
	begin tran;  -- Documentos invalidos o intentos de anulacion, que no quedaron anulados
		update DBIndexIE..Cabecera_Exportacion
			set Estado = 'A'
		where Poliza_Exportacion = '0'
			and exists(select 1
					from DBIndexIE..Detalle_Exportacion de
					where de.Id_Cabecera_Exportacion = DBIndexIE..Cabecera_Exportacion.Id_Cabecera_Exportacion
						and de.Estado <> 'A')
	commit tran;

	
	Begin Tran;  -- Se agrega descripcion a los tipos de documento para hacer match con los registros de la base de datos vieja
		UPDATE FileInfo Set Description  = 'Documento unico aduanero' where name = 'DUA';
		UPDATE FileInfo Set Description  = 'Formulario aduanero unico centro americano' where name = 'FAUCA';
	commit tran;

	Begin Tran;   -- Transacciones duplicadas, se les pone distintivo por linea de transaccion
		update DBIndexIE..Detalle_Importacion 
			set Linea_Importacion = 2
		where Id_Detalle_Importacion in(118794, 119159, 141749)

		update DBIndexIE..Detalle_Exportacion 
			set Linea_Exportacion = 2
		where Id_Detalle_Exportacion in(282853,503799,523571,595781,503734)
	commit tran;

	Begin Tran;
		update DBIndexIE..Detalle_Importacion 
			set Costo_Cif_Dolares = Costo_Cif_Quetzales * 7.8, 
				Costo_Fob_Dolares = Costo_Fob_Quetzales * 7.8 
		where Id_Detalle_Importacion = 157486

--		-- Revision de todas las polizas que tienen tipo de cambio raro
--		select ci.Tipo_Cambio, (di.Costo_Cif_Dolares / case when di.Costo_Cif_Quetzales = 0 then 1 else di.Costo_Cif_Quetzales end) TC, di.Costo_Cif_Dolares, di.Costo_Cif_Quetzales
--		from DBIndexIE..Detalle_Importacion di, DBIndexIE..Cabecera_Importacion ci
----		where Id_Detalle_Importacion = 157486
--		where di.Id_Cabecera_Importacion = ci.Id_Cabecera_Importacion
--			and (di.Costo_Cif_Dolares / case when di.Costo_Cif_Quetzales = 0 then 1 else di.Costo_Cif_Quetzales end) > 10

	commit tran;

	--Begin transaction;
	--	--update DBIndexIE..Relacion_Detalle
	--	--	set estado = 'A'
	--	--where Estado <> 'A'
	--	--	and Id_Detalle_Exportacion in(select Id_Detalle_Exportacion 
	--	--							from DBIndexIE..Detalle_Exportacion de
	--	--							where de.Estado = 'A'
	--	--								and exists(select 1
	--	--										from DBIndexIE..Relacion_Detalle rd
	--	--										where rd.Id_Detalle_Exportacion = de.Id_Detalle_Exportacion
	--	--											and rd.Estado <> 'A'))
	--	update DBIndexIE..Detalle_Exportacion
	--		set estado = 'Z'
	--	where Estado = 'A'
	--		and exists(select 1
	--				from DBIndexIE..Relacion_Detalle rd
	--				where rd.Id_Detalle_Exportacion = Detalle_Exportacion.Id_Detalle_Exportacion
	--					and rd.Estado <> 'A')
	--commit transaction;

END;