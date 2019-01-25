CREATE PROCEDURE [dbo].[spd_FileItemDischargeTransmited]
	@IdFileItemDischarge	INT
AS
	DECLARE	@IdFileDetailStock		INT,
			@IdFileDetailSubstract	INT,
			@IdState				INT,
			@StateTransmited		INT = (SELECT Id FROM [State] WHERE Name = 'Transmitido');

	SELECT	@IdFileDetailStock = IdFileDetailStock, @IdFileDetailSubstract = IdFileDetailSubstract, 
			@IdState = IdState
	  FROM	FileItemDischarge
	 WHERE	Id = @IdFileItemDischarge

	IF(@IdState = @StateTransmited)
		BEGIN
			DECLARE	@IdOpaHeader		INT,
					@IdopaDetailHist	INT,
					@IdopaDetail		INT,
					@OpaHeaderCounter	INT;

			SELECT	@IdOpaHeader = IdOpaHeader, @IdopaDetailHist = Id
			  FROM	OpaDetailHist
			 WHERE	IdFileItemDischarge = @IdFileItemDischarge;

			SELECT	@IdopaDetail = Id
			  FROM	OpaDetail
			 WHERE	IdFileItemDischarge = @IdFileItemDischarge;
			 
			DELETE FROM OpaResponseHist WHERE IdOpaDetail = @IdopaDetailHist;
			DELETE FROM OpaResponse WHERE IdOpaDetail = @IdopaDetail;
			
			DELETE FROM OpaDetailHist WHERE Id = @IdopaDetailHist;
			DELETE FROM OpaDetail WHERE Id = @IdopaDetail;

			SELECT @OpaHeaderCounter = COUNT(*) FROM OpaDetail WHERE IdOpaHeader = @IdOpaHeader;
			IF(@OpaHeaderCounter = 0)
				BEGIN
					DELETE FROM OpaQueue WHERE IdOpaHeader = @IdOpaHeader;
					DELETE FROM OpaQueueLog WHERE IdOpaHeader = @IdOpaHeader;
				END

			EXEC spd_FileItemDischarge @IdFileDetailSubstract, @IdFileDetailStock;
		END
	ELSE
		BEGIN
			RAISERROR (N'El registro que intenta eliminar por este procedimiento no se encuentra transmitido. Por lo tanto no puede eliminarse el registro.',16,1);
		END