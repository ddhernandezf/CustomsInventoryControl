CREATE PROCEDURE [dbo].[spd_Cellar]
	@IdCellar	INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[FileHeader]
				 WHERE	IdCellar = @IdCellar))
	BEGIN
		RAISERROR (N'La bodega cuenta con transacciones en el sistema. No se puede borrar.',16,1);
	END
	ELSE
	BEGIN
		DELETE FROM [Cellar] WHERE Id = @IdCellar;
	END