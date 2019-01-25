CREATE PROCEDURE [dbo].[spd_FileItemDischarge]
	@IdFileDetailSubstrac	INT,
	@IdFileDetailStock	INT
AS
	DECLARE	@Quantity				DECIMAL(18,6),
			@Decrease				DECIMAL(18,6), 
			@Cif					DECIMAL(18,6),
			@Fob					DECIMAL(18,6), 
			@Duties					DECIMAL(18,6),
			@Iva 					DECIMAL(18,6);

	IF EXISTS(	SELECT	*
				  FROM	[OpaDetail]
				 WHERE	IdFileItemDischarge IN (	SELECT	Id
													  FROM	[FileItemDischarge]
													 WHERE	IdFileDetailStock = @IdFileDetailStock
													   AND	IdFileDetailSubstract = @IdFileDetailSubstrac))
		BEGIN
			RAISERROR (N'Este registro se encuentra en proceso de transmisión o ya se encuentra transmitido. Por lo tanto el registro no puede ser borrado.',16,1);
		END
	ELSE
		BEGIN
			SELECT	@IdFileDetailSubstrac = IdFileDetailSubstract, @Quantity = Quantity, @Decrease = Decrease, 
					@Cif = CIFcost, @Fob = FOcost, @Duties = CustomDuties, @Iva = Iva
			  FROM	FileItemDischarge
			 WHERE	IdFileDetailStock = @IdFileDetailStock
			   AND	IdFileDetailSubstract = @IdFileDetailSubstrac;

			UPDATE	ItemInventory
			   SET	Stock = Stock + (@Quantity + @Decrease),
					CIFcost = CIFcost + @Cif,
					FOcost = FOcost + @Fob,
					CustomDuties = CustomDuties + @Duties,
					Iva = Iva + @Iva,
					IdState = 1
			 WHERE	IdFileDetail = @IdFileDetailStock;

			DELETE FROM FileItemDischarge WHERE IdFileDetailStock = @IdFileDetailStock AND IdFileDetailSubstract = @IdFileDetailSubstrac;

			DECLARE @NewCif	DECIMAL(18,6),
					@NewFob	DECIMAL(18,6),
					@NewDai	DECIMAL(18,6),
					@NewIva	DECIMAL(18,6);

			SELECT	@NewCif = SUM(CIFcost), @NewFob = SUM(FOcost), @NewDai = SUM(CustomDuties), @NewIva = SUM(Iva)
			  FROM	FileItemDischarge
			 WHERE	IdFileDetailSubstract = @IdFileDetailSubstrac;

			UPDATE	[FileDetail]
			   SET	CIFCotQuetzal = @NewCif,
					FOCostQuetzal = @NewFob,
					CustomDuties = @NewDai,
					Iva = @NewIva
			WHERE	Id = @IdFileDetailSubstrac;
		END
