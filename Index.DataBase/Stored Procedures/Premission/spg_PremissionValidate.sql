CREATE PROCEDURE [dbo].[spg_PremissionValidate]
	@UserName		VARCHAR(60),
	@RoleName		VARCHAR(100),
	@PremissionName	VARCHAR(100)
AS
	IF((ISNULL(@UserName, '') = '') OR (ISNULL(@PremissionName, '') = ''))
		BEGIN
			SELECT CONVERT(BIT, 0)[Result];
		END
	ELSE
		BEGIN
			IF(ISNULL(@RoleName, '') = '')
				BEGIN
					IF EXISTS(	SELECT	p.*
								  FROM	[User] u INNER JOIN [UserRole] ur ON u.UserName = ur.UserName
												 INNER JOIN [RolePremission] rp ON ur.IdRole = rp.IdRole
												 INNER JOIN [Premission] p ON p.Id = rp.IdPremission
								 WHERE	u.UserName = @UserName
								   AND	p.[Name] = @PremissionName)
						BEGIN
							SELECT CONVERT(BIT, 1)[Result];
						END
					ELSE
						BEGIN
							SELECT CONVERT(BIT, 0)[Result];
						END
				END
			ELSE
				BEGIN
					IF EXISTS(	SELECT	p.*
								  FROM	[User] u INNER JOIN [UserRole] ur ON u.UserName = ur.UserName
												 INNER JOIN [RolePremission] rp ON ur.IdRole = rp.IdRole
												 INNER JOIN [Premission] p ON p.Id = rp.IdPremission
												 INNER JOIN [Role] r ON r.Id = ur.IdRole
								 WHERE	u.UserName = @UserName
								   AND	p.[Name] = @PremissionName
								   AND	r.[Name] = @RoleName)
						BEGIN
							SELECT CONVERT(BIT, 1)[Result];
						END
					ELSE
						BEGIN
							SELECT CONVERT(BIT, 0)[Result];
						END
				END
		END