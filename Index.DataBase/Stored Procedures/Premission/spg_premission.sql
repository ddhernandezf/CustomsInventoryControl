CREATE PROCEDURE [dbo].[spg_premission]
	@IdRole			INT
AS
	IF(ISNULL(@IdRole,0)= 0)
		BEGIN
			SELECT	pr.IdPremission, pr.IdRole, p.IdParent, p.Area, p.Controller, p.[Action],
					p.[Parameters], p.Name, p.[Description], r.Name[RoleName]
			  FROM	[Premission] p INNER JOIN [RolePremission] pr ON p.Id = pr.IdPremission
								   INNER JOIN [Role] r ON r.Id = pr.IdRole
		END
	ELSE
		BEGIN
			SELECT	pr.IdPremission, pr.IdRole, p.IdParent, p.Area, p.Controller, p.[Action],
					p.[Parameters], p.Name, p.[Description], r.Name[RoleName]
			  FROM	[Premission] p INNER JOIN [RolePremission] pr ON p.Id = pr.IdPremission
								   INNER JOIN [Role] r ON r.Id = pr.IdRole
			 WHERE	pr.IdRole = @IdRole
		END
