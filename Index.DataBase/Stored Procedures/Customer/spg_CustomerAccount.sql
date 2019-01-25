CREATE PROCEDURE [dbo].[spg_CustomerAccount]
	@UserName VARCHAR(60)
AS
	DECLARE @TempData TABLE (
		[IdPerson] INT NOT NULL, 
		[EnterpriseName] VARCHAR(400) NULL,
		[IdAccount] INT NOT NULL,
		[Account] VARCHAR(100) NOT NULL
	)

	INSERT INTO @TempData(IdPerson, EnterpriseName, IdAccount, Account)
	SELECT	c.IdPerson, p.EnterpriseName, ca.IdAccount, a.[Name][Account]
	  FROM	[CustomerUser] cu INNER JOIN [Customer] c ON c.IdPerson = cu.IdCustomer
							  INNER JOIN [Person] p ON p.Id = c.IdPerson
							  INNER JOIN [CustomerAccount] ca ON ca.IdCustomer = c.IdPerson
							  INNER JOIN [Account] a ON a.Id = ca.IdAccount
	 WHERE	cu.UserName = @UserName
	 ORDER BY P.EnterpriseName

	SELECT DISTINCT IdAccount, Account
	  FROM	@TempData
