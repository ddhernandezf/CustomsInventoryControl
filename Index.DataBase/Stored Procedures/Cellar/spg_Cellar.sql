CREATE PROCEDURE [dbo].[spg_Cellar]
	@IdCellar	INT
AS
	IF(ISNULL(@IdCellar,0) = 0)
		BEGIN
			SELECT	Id,Name,[Address]
			  FROM	[Cellar]
		END
	ELSE
		BEGIN
			SELECT	Id,Name,[Address]
			  FROM	[Cellar]
			 WHERE	Id = @IdCellar
		END
