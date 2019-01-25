CREATE PROCEDURE [dbo].[spd_Resolution]
	@Id	INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[ResolutionAccountingItem]
				 WHERE	IdResolution = @Id))
		BEGIN
			RAISERROR (N'La resolución tiene partidas relacionadas. No se puede borrar el registro.',16,1);
		END
	ELSE IF(EXISTS(	SELECT	*
				  FROM	[Item]
				 WHERE	IdResolution = @Id))
		BEGIN
			RAISERROR (N'La resolución se encuentra relacionada a productos y materias primas. No se puede borrar el registro.',16,1);
		END
	ELSE
		BEGIN
			DELETE FROM [Resolution] WHERE Id = @Id;
		END
