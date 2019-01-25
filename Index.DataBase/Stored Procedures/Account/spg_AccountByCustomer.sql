CREATE PROCEDURE [dbo].[spg_AccountByCustomer]
	@IdCustomer		INT
AS
	SELECT	a.Id[IdAccount], a.[Name], a.[Description]
	  FROM	[Account] a INNER JOIN [CustomerAccount] ca ON a.Id = ca.IdAccount
	 WHERE	ca.IdCustomer = IdCustomer
