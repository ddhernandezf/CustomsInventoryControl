CREATE PROCEDURE [dbo].[spi_OpaDetail]
	@IdOpaHeader INT,
	@IdFileItemDischarge INT,
	@IdFileHeaderSubstract INT,
	@IdFileDetailSubstract INT,
	@IdDocumentSubstract VARCHAR(100),
	@TransactionLineSubstract INT,
	@QuantitySubstract DECIMAL(18,6),
	@CifSubstract DECIMAL(18,6),
	@FobSubstract DECIMAL(18,6),
	@CustomDutiesSubstract DECIMAL(18,6),
	@IvaSubstract DECIMAL(18,6),
	@IdFileHeaderStock INT,
	@IdFileDetailStock INT,
	@IdDocumentStock VARCHAR(100),
	@TransactionLineStock INT
AS
	
	DECLARE @IdStateCola INT
	SELECT @IdStateCola = Id FROM [State] WHERE Name = 'Cola'

	INSERT INTO [OpaDetail] (IdOpaHeader, IdState, IdFileItemDischarge, IdFileHeaderSubstract, IdFileDetailSubstract, IdDocumentSubstract,
							TransactionLineSubstract, QuantitySubstract, CifSubstract, FobSubstract, CustomDutiesSubstract, IvaSubstract,
							IdFileHeaderStock, IdFileDetailStock, IdDocumentStock, TransactionLineStock)
	VALUES(@IdOpaHeader, @IdStateCola, @IdFileItemDischarge, @IdFileHeaderSubstract, @IdFileDetailSubstract, @IdDocumentSubstract,
			@TransactionLineSubstract, @QuantitySubstract, @CifSubstract, @FobSubstract, @CustomDutiesSubstract, @IvaSubstract,
			@IdFileHeaderStock, @IdFileDetailStock, @IdDocumentStock, @TransactionLineStock);

	UPDATE	[FileItemDischarge]
	   SET	IdState = @IdStateCola
	 WHERE	Id = @IdFileItemDischarge

	UPDATE	[FileHeader]
	   SET	IdState = @IdStateCola
	 WHERE	Id IN (@IdFileHeaderStock, @IdFileHeaderSubstract)

	UPDATE	[FileDetail]
	   SET	IdState = @IdStateCola
	 WHERE	Id IN (@IdFileDetailStock, @IdFileDetailSubstract)