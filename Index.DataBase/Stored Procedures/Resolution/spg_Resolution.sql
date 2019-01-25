CREATE PROCEDURE [dbo].[spg_Resolution]
	@Id	INT
AS
	IF(ISNULL(@Id, 0) = 0)
	BEGIN
		SELECT	r.Id, r.IdCustomer, 
				CASE WHEN P.IsEnterprise = 1 THEN
					p.EnterpriseName
				ELSE
					CASE WHEN p.LastName IS NULL THEN
						p.FirstName
					ELSE
						CONCAT(p.FirstName, ' ', p.LastName)
					END
				END [CustomerName],
				r.IdAccount, a.[Name][AccountName], r.[Name], r.[Description], r.RateDate
		  FROM	[Resolution] r INNER JOIN [Account] a ON r.IdAccount = a.Id 
							   INNER JOIN [Customer] c ON c.IdPerson = r.IdCustomer
							   INNER JOIN [Person] p ON p.Id = c.IdPerson;
	END
	ELSE
	BEGIN
		SELECT	r.Id, r.IdCustomer, 
				CASE WHEN P.IsEnterprise = 1 THEN
					p.EnterpriseName
				ELSE
					CASE WHEN p.LastName IS NULL THEN
						p.FirstName
					ELSE
						CONCAT(p.FirstName, ' ', p.LastName)
					END
				END [CustomerName],
				r.IdAccount, a.[Name][AccountName], r.[Name], r.[Description], r.RateDate
		  FROM	[Resolution] r INNER JOIN [Account] a ON r.IdAccount = a.Id 
							   INNER JOIN [Customer] c ON c.IdPerson = r.IdCustomer
							   INNER JOIN [Person] p ON p.Id = c.IdPerson
		 WHERE	r.Id = @Id;
	END
