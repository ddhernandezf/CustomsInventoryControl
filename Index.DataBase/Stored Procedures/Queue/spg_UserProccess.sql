CREATE PROCEDURE [dbo].[spg_UserProccess]
	@IdOpaHeader	INT
AS
	SELECT	oh.UserName, oh.IdAccount, a.Name[AccountName], oh.IdPriority, p.Name[PriorityName], oh.IdState,
			s.Name[StateName], oh.StartDateHeader, oh.EndDateHeader, OH.IdCustomer,
			(SELECT	CASE WHEN p.IsEnterprise = 1
						THEN p.EnterpriseName
						ELSE CASE WHEN p.LastName IS NULL
							THEN p.FirstName
							ELSE CONCAT(p.FirstName, ' ', p.LastName)
						END
					END
			   FROM	Person p
			  WHERE p.Id = oh.IdCustomer)[CustomerName],
			  (SELECT	TOP 1 e.Email
				  FROM	[Email] e INNER JOIN [EmailType] et ON e.IdEmailType = et.Id
								  INNER JOIN [User] u ON u.IdPerson = e.IdPerson
				 WHERE	et.[Description] = 'Trabajo'
				   AND	u.UserName = oh.UserName)[Email]
	  FROM	[OpaHeader] oh INNER JOIN [Account] a ON a.Id = oh.IdAccount
						   INNER JOIN [Priority] p ON p.Id = oh.IdPriority
						   INNER JOIN [State] s ON s.Id = oh.IdState
	 WHERE	oh.Id = @IdOpaHeader