CREATE PROCEDURE [dbo].[spu_CustomerDischarge]
	@IdCustomer				INT,
	@FilePath				VARCHAR(2000),
	@DocumentName			VARCHAR(300),
	@DocumentDescription	VARCHAR(1000),
	@RegisterUser			VARCHAR(60)
AS
	UPDATE	[CustomerDischarge]
	   SET	FilePath = @FilePath, 
			DocumentName = @DocumentName, 
			DocumentDescription = @DocumentDescription,
			RegisterDate = GETDATE(),
			RegisterUser = @RegisterUser
	 WHERE	IdCustomer = @IdCustomer