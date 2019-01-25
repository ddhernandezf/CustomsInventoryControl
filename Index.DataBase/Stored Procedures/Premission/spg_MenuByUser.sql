CREATE PROCEDURE [dbo].[spg_MenuByUser]
	@RoleName VARCHAR(100),
	@UserName VARCHAR(60)
AS
	DECLARE	@IdRole	INT;

	SELECT @IdRole = Id FROM [Role] WHERE [Name] = @RoleName;

	SELECT	p.Id, p.Name, p.[Description], p.Area, p.Controller, p.[Action], p.[Parameters],
			p.IdParent, p.[Image], p.ShowMenu, p.[Order], P.HasCredentials
	  FROM	[UserRole] ur INNER JOIN [RolePremission] rp ON ur.IdRole = rp.IdRole
						  INNER JOIN [Premission] p ON p.Id = rp.IdPremission
	 WHERE	ur.UserName = @UserName
	   AND	rp.IdRole = @IdRole
	 ORDER BY IdParent,[Order]

	--SELECT	p.Id, p.Name, p.[Description], p.Area, p.Controller, p.[Action], p.[Parameters],
	--		p.IdParent, p.[Image], p.ShowMenu, p.[Order], P.HasCredentials
	--  FROM	[Premission] p INNER JOIN [RolePremission] rp ON rp.IdPremission = p.Id
	--					   INNER JOIN [Role] r ON r.Id = rp.IdRole
	--					   INNER JOIN [UserRole] ur ON ur.IdRole = r.Id
	-- WHERE	p.ShowMenu = 1
	--   AND	ur.UserName = @UserName
	--   AND	r.Name = @RoleName
	-- ORDER BY IdParent, [Order]