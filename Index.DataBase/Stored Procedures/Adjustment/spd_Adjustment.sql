﻿CREATE PROCEDURE [dbo].[spd_Adjustment]
	@IdFileItemDischarge	INT
AS
	DECLARE	@Quantity				DECIMAL(18,6),
			@Decrease				DECIMAL(18,6), 
			@Cif					DECIMAL(18,6),
			@Fob					DECIMAL(18,6), 
			@Duties					DECIMAL(18,6),
			@Iva 					DECIMAL(18,6),
			@IdFileDetailSubstrac	INT,
			@IdFileDetailStock	INT;

	IF EXISTS(	SELECT	*
				  FROM	[OpaDetail]
				 WHERE	IdFileItemDischarge IN (	SELECT	Id
													  FROM	[FileItemDischarge]
													 WHERE	Id = @IdFileItemDischarge))
		BEGIN
			RAISERROR (N'Este registro se encuentra en proceso de transmisión o ya se encuentra transmitido. Por lo tanto el registro no puede ser borrado.',16,1);
		END
	ELSE
		BEGIN
			SELECT	@IdFileDetailSubstrac = IdFileDetailSubstract, @Quantity = Quantity, @Decrease = Decrease, 
					@Cif = CIFcost, @Fob = FOcost, @Duties = CustomDuties, @Iva = Iva, @IdFileDetailStock = IdFileDetailStock
			  FROM	FileItemDischarge
			 WHERE	Id = @IdFileItemDischarge;

			UPDATE	ItemInventory
			   SET	Stock = Stock + (@Quantity + @Decrease),
					CIFcost = CIFcost + @Cif,
					FOcost = FOcost + @Fob,
					CustomDuties = CustomDuties + @Duties,
					Iva = Iva + @Iva,
					IdState = 1
			 WHERE	IdFileDetail = @IdFileDetailStock;

			DELETE FROM FileItemDischarge WHERE Id = @IdFileItemDischarge;
		END
