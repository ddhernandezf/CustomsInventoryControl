CREATE PROCEDURE [dbo].[spd_role]
	@Id INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[UserRole]
				 WHERE	IdRole = @Id))
	BEGIN
		RAISERROR (N'El rol cuenta con usuarios asignados. No se puede borrar.',16,1);
	END
	ELSE
	BEGIN
		DELETE FROM [RolePremission] WHERE IdRole = @Id;
		DELETE FROM [Role] WHERE Id = @Id;
	END