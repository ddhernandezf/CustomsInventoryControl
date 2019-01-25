CREATE PROCEDURE [dbo].[spg_PremissionByRole]
	@IdRole INT
AS
	SELECT	p.Id, p.Name, p.[Description], p.Area, p.Controller, p.[Action],
			p.[Parameters], p.IdParent, p.[Image], p.ShowMenu, p.[Order], 1[PremissionAssigned]
	  FROM	[RolePremission] r INNER JOIN [Premission] p  ON r.IdPremission = p.Id
	 WHERE	r.IdRole= @IdRole
	UNION
	SELECT	p.Id, p.Name, p.[Description], p.Area, p.Controller, p.[Action],
			p.[Parameters], p.IdParent, p.[Image], p.ShowMenu, p.[Order], 0[PremissionAssigned]
	  FROM	[Premission] p
	 WHERE	P.Id NOT IN (SELECT IdPremission FROM [RolePremission] WHERE IdRole = @IdRole)