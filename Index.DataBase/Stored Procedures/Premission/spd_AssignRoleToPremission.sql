CREATE PROCEDURE [dbo].[spd_AssignRoleToPremission]
	@IdRole			INT,
	@IdPremission	INT
AS
	IF(ISNULL(@IdPremission,0) = 0)
		BEGIN
			DELETE FROM [RolePremission] WHERE IdRole = @IdRole;
		END
	ELSE
		BEGIN
			DELETE FROM [RolePremission] WHERE IdRole = @IdRole AND	IdPremission = @IdPremission;
		END