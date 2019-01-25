CREATE PROCEDURE [dbo].[spg_CustomerAccountToAssing]
	@IdCustomer	INT
AS
	DECLARE @TempData TABLE (
		[IdAccount] INT NOT NULL,
		[Name] VARCHAR(100) NOT NULL,
		[IsAssigned] BIT NOT NULL
	)
	
	INSERT INTO @TempData(IdAccount, [Name], IsAssigned)
	SELECT	ca.IdAccount, a.[Name], 1[IsAssigned]
	  FROM	[CustomerAccount] ca INNER JOIN [Account] a ON a.Id = ca.IdAccount
	 WHERE	IdCustomer = @IdCustomer

	INSERT INTO @TempData(IdAccount, [Name], IsAssigned)
	SELECT	Id[IdAccount], [Name], 0[IsAssigned]
	  FROM	[Account]
	 WHERE	Id NOT IN (SELECT IdAccount FROM @TempData)

	SELECT	IdAccount, [Name], IsAssigned
	  FROM	@TempData