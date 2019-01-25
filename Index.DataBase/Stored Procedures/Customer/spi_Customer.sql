CREATE PROCEDURE [dbo].[spi_Customer]
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
	DECLARE @IdPerson	INT;
	EXEC spi_Enterprise @EnterpriseName, @Nit, @IdPerson OUT, @RegisterUser;
	
	IF EXISTS(	SELECT	*
				  FROM	[Customer]
				 WHERE	IdPerson = @IdPerson)
		BEGIN
			RAISERROR (N'El cliente %s ya se encuentra registrado.',16,1, @EnterpriseName);
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdPerson, 0) <> 0)
				BEGIN
					INSERT INTO [Customer](IdPerson,LegalRepresentative,PersonCode,ImporterCode,ExporterCode,Observations,RegisterDate, 
											RegisterUser, BondEndDate)
					VALUES(@IdPerson, @LegalRepresentative, @PersonCode, @ImporterCode, @ExporterCode,@Observations, GETDATE(), 
							@RegisterUser, @BondEndDate);
				END
		END