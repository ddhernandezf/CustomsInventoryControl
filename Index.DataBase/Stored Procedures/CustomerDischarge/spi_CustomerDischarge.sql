CREATE PROCEDURE [dbo].[spi_CustomerDischarge]
	@IdCustomer				INT,
	@FilePath				VARCHAR(2000),
	@DocumentName			VARCHAR(300),
	@DocumentDescription	VARCHAR(1000),
	@RegisterUser			VARCHAR(60)
AS
	INSERT INTO [CustomerDischarge](IdCustomer, FilePath, DocumentName, DocumentDescription
									, RegisterDate, RegisterUser)
	VALUES(@IdCustomer, @FilePath, @DocumentName, @DocumentDescription, 
			GETDATE(), @RegisterUser);
