CREATE PROCEDURE [dbo].[spg_Country]
	@IdCountry	INT
AS
	IF(ISNULL(@IdCountry,0) = 0)
		BEGIN
			SELECT	Id, Name, IdParent
			  FROM	[Country];
		END
	ELSE
		BEGIN
			SELECT	Id, Name, IdParent
			  FROM	[Country]
			 WHERE	Id = @IdCountry;
		END
