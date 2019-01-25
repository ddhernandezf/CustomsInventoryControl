CREATE PROCEDURE [dbo].[spd_OpaDetailItem]
	@IdOpaDetail	INT
AS
	DECLARE @IdStateError	INT = (SELECT Id FROM [State] WHERE [Name] = 'Error Transmisión');

	IF EXISTS (	SELECT	*
				  FROM	OpaDetail
				 WHERE	Id = @IdOpaDetail
				   AND	IdState = @IdStateError)
		BEGIN
			DECLARE	@IdFileItemDischarge	INT,
					@IdFileHeaderSubstract	INT,
					@IdFileDetailSubstract	INT,
					@IdFileHeaderStock		INT,
					@IdFileDetailStock		INT;

			SELECT	@IdFileItemDischarge = IdFileItemDischarge, @IdFileHeaderSubstract = IdFileHeaderSubstract,
					@IdFileHeaderStock = IdFileHeaderStock, @IdFileDetailSubstract = IdFileDetailSubstract,
					@IdFileDetailStock = IdFileDetailStock
			  FROM	OpaDetail
			 WHERE	Id = @IdOpaDetail
			   AND	IdState = @IdStateError;

			DECLARE @ItemDischargeState	INT,
					@IdGrabado			INT = (SELECT Id FROM [State] WHERE [Name] = 'Grabado'),
					@IdIngresado		INT = (SELECT Id FROM [State] WHERE [Name] = 'Ingresado');

			UPDATE	FileItemDischarge
			   SET	IdState = @IdIngresado
			 WHERE	Id = @IdFileItemDischarge;

			UPDATE	FileHeader
			   SET	IdState = @IdGrabado
			 WHERE	Id IN (@IdFileHeaderStock, @IdFileHeaderSubstract);

			UPDATE	FileDetail
			   SET	IdState = @IdGrabado
			 WHERE	Id IN (@IdFileDetailStock, @IdFileDetailSubstract);

			DELETE FROM	[OpaResponse] WHERE	IdOpaDetail= @IdOpaDetail;
			DELETE FROM [OpaDetail] WHERE Id = @IdOpaDetail;
		END
