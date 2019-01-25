CREATE PROCEDURE [dbo].[spg_UnitMeasurement]
	@Id	INT
AS
	IF(ISNULL(@Id,0) = 0)
		BEGIN
			SELECT Id, Name, [Description], Symbol
			  FROM	[UnitMeasurement]
		END
	ELSE
		BEGIN
			SELECT	Id, Name, [Description], Symbol
			  FROM	[UnitMeasurement]
			 WHERE	Id = @Id
		END
