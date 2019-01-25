CREATE PROCEDURE [dbo].[spu_Supplier]
	@IdPerson		INT,
	@FirstName		VARCHAR(150),
	@LastName		VARCHAR(150),
	@Nit			VARCHAR(15),
	@Observations	VARCHAR(1000),
	@RegisterUser	VARCHAR(60),
	@IsDestinySupplier	BIT
AS
	EXEC spu_Person @IdPerson, @FirstName, @LastName, @Nit, @RegisterUser;

	UPDATE [Supplier]
	   SET	Observations = @Observations,
			RegisterDate = GETDATE(),
			RegisterUser = @RegisterUser,
			IsDestinySupplier = IsDestinySupplier
	 WHERE IdPerson = @IdPerson;
