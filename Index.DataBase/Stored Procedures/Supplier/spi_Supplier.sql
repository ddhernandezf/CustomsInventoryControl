CREATE PROCEDURE [dbo].[spi_Supplier]
	@FirstName			VARCHAR(150),
	@LastName			VARCHAR(150),
	@Nit				VARCHAR(15),
	@Observations		VARCHAR(1000),
	@RegisterUser		VARCHAR(60),
	@IsDestinySupplier	BIT
AS
	DECLARE @IdPerson	INT;
	EXEC spi_Person @FirstName,@LastName,@Nit,@IdPerson OUT, @RegisterUser;

	IF(EXISTS(	SELECT	*
				  FROM	[Supplier]
				 WHERE	IdPerson = @IdPerson))
	BEGIN
		RAISERROR (N'El proveedor %s ya se encuentra registrado.',16,1, @FirstName);
	END
	ELSE
	BEGIN
		INSERT INTO [Supplier](IdPerson,Observations, RegisterDate, RegisterUser, IsDestinySupplier)
		VALUES (@IdPerson, @Observations, GETDATE(), @RegisterUser, @IsDestinySupplier);
	END