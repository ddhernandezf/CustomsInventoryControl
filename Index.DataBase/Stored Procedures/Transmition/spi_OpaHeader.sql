CREATE PROCEDURE [dbo].[spi_OpaHeader]
	@IdCustomer		INT,
	@IdAccount		INT,
	@IdPriority		INT,
	@StartDate		DATE,
	@EndDate		DATE,
	@RegisterUser	VARCHAR(60),
	@IdOpaHeader	INT OUT
AS
	DECLARE @IdStateCola	INT

	SELECT @IdStateCola = Id FROM [State] WHERE Name = 'Cola'

	INSERT INTO [OpaHeader](UserName, IdCustomer, IdAccount, IdPriority, IdState, StartDateHeader, EndDateHeader, EnterpriseCode,
							Nit, ImporterCode, ExporterCode, RegisterUser, RegisterDate)
	SELECT	@RegisterUser, @IdCustomer, @IdAccount, @IdPriority, @IdStateCola, @StartDate, @EndDate, c.PersonCode, 
			p.Nit, c.ImporterCode, c.ExporterCode, @RegisterUser, GETDATE()
	  FROM	[Customer] c INNER JOIN [Person] p ON p.Id = c.IdPerson
	 WHERE	IdPerson = @IdCustomer

	 SET @IdOpaHeader = SCOPE_IDENTITY();

	 INSERT INTO[OpaQueue](IdOpaHeader,IdPriority, IdState, [DEscription])
	 VALUES (@IdOpaHeader, @IdPriority, @IdStateCola, NULL)