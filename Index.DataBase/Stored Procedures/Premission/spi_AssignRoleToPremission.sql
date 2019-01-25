CREATE PROCEDURE [dbo].[spi_AssignRoleToPremission]
	@IdRole			INT,
	@IdPremission	INT,
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[RolePremission]
				 WHERE	IdRole = @IdRole
				   AND	IdPremission = @IdPremission))
		BEGIN
			RAISERROR (N'Este permiso ya ue asignado a este rol.',16,1);
		END
	ELSE
		BEGIN
			INSERT INTO [RolePremission] (IdRole, IdPremission, RegisterDate, RegisterUser)
			VALUES (@IdRole, @IdPremission, GETDATE(), @RegisterUser);
		END
