CREATE PROCEDURE [dbo].[spg_RoleByUserToAssign]
	@UserName	VARCHAR(60)
AS
	SELECT	r.Id, r.Name, r.[Description], 1[RoleAssigned]
	  FROM	[UserRole] u INNER JOIN [Role] r on r.Id = u.IdRole
	 WHERE	UserName = @UserName
	UNION
	SELECT	Id, Name, [Description], 0[RoleAssigned]
	  FROM	[Role]
	 WHERE	Id not in (SELECT IdRole FROM [UserRole] WHERE UserName = @UserName)