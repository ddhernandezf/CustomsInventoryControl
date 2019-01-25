CREATE PROCEDURE [dbo].[spg_Customs]
	@Id			INT,
	@IdCountry	INT
AS
	IF(ISNULL(@Id,0) = 0)
		BEGIN
			IF(ISNULL(@IdCountry,0) = 0)
				BEGIN
					SELECT	c.Id, c.IdCountry, cn.Name [CountryName], c.Name, c.[Address], c.[Code]
					  FROM	[Customs] c INNER JOIN [Country] cn ON c.IdCountry = cn.Id
					 ORDER BY cn.Name
				END
			ELSE
				BEGIN
					SELECT	c.Id, c.IdCountry, cn.Name [CountryName], c.Name, c.[Address], c.[Code]
					  FROM	[Customs] c INNER JOIN [Country] cn ON c.IdCountry = cn.Id
					 WHERE	c.IdCountry = @IdCountry
					 ORDER BY cn.Name
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdCountry,0) = 0)
				BEGIN
					SELECT	c.Id, c.IdCountry, cn.Name [CountryName], c.Name, c.[Address], c.[Code]
					  FROM	[Customs] c INNER JOIN [Country] cn ON c.IdCountry = cn.Id
					 WHERE	c.Id = @Id
					 ORDER BY cn.Name
				END
			ELSE
				BEGIN
					SELECT	c.Id, c.IdCountry, cn.Name [CountryName], c.Name, c.[Address], c.[Code]
					  FROM	[Customs] c INNER JOIN [Country] cn ON c.IdCountry = cn.Id
					 WHERE	c.Id = @Id
					   AND	c.IdCountry = @IdCountry
					 ORDER BY cn.Name
				END
		END
