CREATE PROCEDURE [dbo].[spd_AssignUserToRole]
	@UserName	VARCHAR(60),
	@IdRole		INT
AS
	DELETE FROM [UserRole] WHERE UserName = @UserName AND IdRole = @IdRole;