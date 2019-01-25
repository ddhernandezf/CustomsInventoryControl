CREATE PROCEDURE [dbo].[spd_OpaDetail]
	@IdOpaHeader	INT
AS
	DECLARE @OpaDetailTemp TABLE (
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
	  FROM	[OpaDetail] od
	 WHERE	od.IdOpaHeader = @IdOpaHeader

	DECLARE	@IdCola			INT,
			@IdIngresado	INT,
			@IdGrabado		INT,
			@IdError		INT,
			@IdTransmitido	INT,
			@RegCount		INT,
			--@InCola			INT,
			--@Transmitidos	INT,
			@ConError		INT

	SELECT @IdCola = Id FROM [State] WHERE [Name] = 'Cola';
	SELECT @IdIngresado = Id FROM [State] WHERE [Name] = 'Ingresado';
	SELECT @IdGrabado = Id FROM [State] WHERE [Name] = 'Grabado';
	SELECT @IdTransmitido = Id FROM [State] WHERE [Name] = 'Transmitido';
	SELECT @IdError = Id FROM [State] WHERE [Name] = 'Error Transmisión';

	SELECT	@RegCount = COUNT(*)
	  FROM	@OpaDetailTemp;

	--SELECT	@InCola = COUNT(*)
	--  FROM	@OpaDetailTemp
	-- WHERE	IdState = @IdCola;

	--SELECT	@Transmitidos = COUNT(*)
	--  FROM	@OpaDetailTemp
	-- WHERE	IdState = @IdTransmitido;

	SELECT	@ConError = COUNT(*)
	  FROM	@OpaDetailTemp
	 WHERE	IdState = @IdError;

	IF(@RegCount = 0)
		BEGIN
			UPDATE	FileItemDischarge
			   SET	IdState = @IdIngresado
			 WHERE	Id IN (	SELECT	DISTINCT IdFileItemDischarge 
							  FROM	@OpaDetailTemp)

			UPDATE	FileDetail
			   SET	IdState = @IdGrabado
			 WHERE	Id IN (	SELECT	DISTINCT IdFileDetailStock
							  FROM	@OpaDetailTemp
							UNION
							SELECT	DISTINCT IdFileDetailSubstract
							  FROM	@OpaDetailTemp)

			UPDATE	FileHeader
			   SET	IdState = @IdGrabado
			 WHERE	Id IN (	SELECT	DISTINCT IdFileHeaderStock
							  FROM	@OpaDetailTemp
							UNION
							SELECT	DISTINCT IdFileHeaderSubstract
							  FROM	@OpaDetailTemp)

			DELETE FROM [OpaResponse] WHERE IdOpaDetail IN (SELECT Id FROM [OpaDetail] WHERE IdOpaHeader = @IdOpaHeader);
			DELETE FROM [OpaDetail] WHERE IdOpaHeader = @IdOpaHeader;
			DELETE FROM [OpaQueue] WHERE IdOpaHeader = @IdOpaHeader;
			DELETE FROM [OpaHeader] WHERE Id = @IdOpaHeader;
		END
	ELSE
		BEGIN
			IF(@ConError = @RegCount)
				BEGIN
					UPDATE	FileItemDischarge
					   SET	IdState = @IdIngresado
					 WHERE	Id IN (	SELECT	DISTINCT IdFileItemDischarge 
									  FROM	@OpaDetailTemp)

					UPDATE	FileDetail
					   SET	IdState = @IdGrabado
					 WHERE	Id IN (	SELECT	DISTINCT IdFileDetailStock
									  FROM	@OpaDetailTemp
									UNION
									SELECT	DISTINCT IdFileDetailSubstract
									  FROM	@OpaDetailTemp)

					UPDATE	FileHeader
					   SET	IdState = @IdGrabado
					 WHERE	Id IN (	SELECT	DISTINCT IdFileHeaderStock
									  FROM	@OpaDetailTemp
									UNION
									SELECT	DISTINCT IdFileHeaderSubstract
									  FROM	@OpaDetailTemp)
					
					DELETE FROM [OpaResponse] WHERE IdOpaDetail IN (SELECT Id FROM [OpaDetail] WHERE IdOpaHeader = @IdOpaHeader);
					DELETE FROM [OpaDetail] WHERE IdOpaHeader = @IdOpaHeader;
					DELETE FROM [OpaQueue] WHERE IdOpaHeader = @IdOpaHeader;
					DELETE FROM [OpaHeader] WHERE Id = @IdOpaHeader;
				END
			ELSE
				BEGIN
					RAISERROR (N'Algunos registros se encuentran en proceso o transmitidos. El batch no se puede eliminar.',16,1);
				END
		END