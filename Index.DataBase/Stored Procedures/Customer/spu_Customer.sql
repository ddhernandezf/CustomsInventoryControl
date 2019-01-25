CREATE PROCEDURE [dbo].[spu_Customer]
	@IdPerson				INT,
	@EnterpriseName			VARCHAR(400),
	@Nit					VARCHAR(15),
	@LegalRepresentative	VARCHAR(300),
	@PersonCode				NVARCHAR(100),
	@ImporterCode			NVARCHAR(100),
	@ExporterCode			NVARCHAR(100),
	@BondEndDate			DATE,
	@Observations			VARCHAR(1000),
	@RegisterUser			VARCHAR(60)
AS
	EXEC spu_Enterprise @IdPerson, @EnterpriseName, @Nit, @RegisterUser;

	UPDATE	[Customer]
	   SET	LegalRepresentative = @LegalRepresentative, 
			PersonCode = @PersonCode, 
			ImporterCode = @ImporterCode, 
			ExporterCode = @ExporterCode, 
			BondEndDate = @BondEndDate,
			Observations = @Observations,
			RegisterDate = GETDATE(),
			RegisterUser = @RegisterUser
	 WHERE	IdPerson = @IdPerson