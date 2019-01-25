CREATE PROCEDURE [dbo].[spd_UnitMeasurement]
	@Id	INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Item]
				 WHERE	IdUnitMeasurement = @Id))
	BEGIN
		RAISERROR (N'La unidad de medida cuenta con articulos relacionados. No se puede borrar.',16,1);
	END
	ELSE
	BEGIN
		DELETE FROM [UnitMeasurement] WHERE Id = @Id;
	END