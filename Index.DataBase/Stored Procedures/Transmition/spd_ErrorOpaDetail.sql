CREATE PROCEDURE [dbo].[spd_ErrorOpaDetail]
	@IdOpaHeader	INT
AS
	DECLARE	@IdError	INT = (SELECT Id FROM [State] WHERE [Name] = 'Error Transmisión')

	DECLARE	@OpaDetailTemp TABLE(
		[Id] INT NOT NULL,
		[IdOpaHeader] INT NOT NULL,
		[IdState] INT NOT NULL,
		[IdFileItemDischarge] INT NOT NULL,
		[IdFileHeaderSubstract] INT NOT NULL,
		[IdFileDetailSubstract] INT NOT NULL,
		[IdDocumentSubstract] VARCHAR(100) NOT NULL,
		[TransactionLineSubstract] INT NOT NULL,
		[QuantitySubstract] DECIMAL(18,6) NOT NULL,
		[CifSubstract] DECIMAL(18,6) NOT NULL,
		[FobSubstract] DECIMAL(18,6) NOT NULL,
		[CustomDutiesSubstract] DECIMAL(18,6) NOT NULL,
		[IvaSubstract] DECIMAL(18,6) NOT NULL,
		[IdFileHeaderStock] INT NOT NULL,
		[IdFileDetailStock] INT NOT NULL,
		[IdDocumentStock] VARCHAR(100) NOT NULL,
		[TransactionLineStock] INT NOT NULL,
		[StartDate] DATETIME NULL,
		[EndDate] DATETIME NULL
	)

	INSERT INTO @OpaDetailTemp
	SELECT	*
	  FROM	OpaDetail
	 WHERE	IdOpaHeader = @IdOpaHeader
	   AND	IdState = @IdError;

	IF EXISTS(SELECT * FROM @OpaDetailTemp)
		BEGIN
			DECLARE @IdGrabado			INT = (SELECT Id FROM [State] WHERE [Name] = 'Grabado'),
					@IdIngresado		INT = (SELECT Id FROM [State] WHERE [Name] = 'Ingresado');

			UPDATE	FileItemDischarge
			   SET	IdState = @IdIngresado
			 WHERE	Id IN (SELECT IdFileItemDischarge FROM @OpaDetailTemp);

			UPDATE	FileHeader
			   SET	IdState = @IdGrabado
			 WHERE	Id IN (SELECT	IdHeader
							  FROM	(	SELECT IdFileHeaderStock[IdHeader] FROM @OpaDetailTemp
										UNION 
										SELECT IdFileHeaderSubstract[IdHeader] FROM @OpaDetailTemp) a);

			UPDATE	FileDetail
			   SET	IdState = @IdGrabado
			 WHERE	Id IN (SELECT	IdDetail
							  FROM	(	SELECT IdFileDetailStock[IdDetail] FROM @OpaDetailTemp
										UNION 
										SELECT IdFileDetailSubstract[IdDetail] FROM @OpaDetailTemp) a);

			DELETE FROM	[OpaResponse] WHERE	IdOpaDetail IN (SELECT Id FROM @OpaDetailTemp);
			DELETE FROM [OpaDetail] WHERE Id IN (SELECT Id FROM @OpaDetailTemp);
		END