CREATE PROCEDURE [dbo].[spg_ValidatePremision]
	@UserName VARCHAR(60),
	@RoleName VARCHAR(100),
	@PremissionName VARCHAR(100)
AS
	IF EXISTS(	SELECT	*
			  FROM	[User] u INNER JOIN [UserRole] ur ON ur.UserName = u.UserName 
							 INNER JOIN [Role] r ON r.Id = ur.IdRole
							 INNER JOIN [RolePremission] rp ON rp.IdRole = r.Id
							 INNER JOIN [Premission] p ON p.Id = rp.IdPremission
			 WHERE	u.UserName = @UserName
			   AND	r.Name = @RoleName
			   AND	p.Name = @PremissionName)
	BEGIN
		SELECT 1[Result];
	END
	ELSE
	BEGIN
		SELECT 0[Result];
	END