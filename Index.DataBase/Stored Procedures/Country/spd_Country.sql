CREATE PROCEDURE [dbo].[spd_Country]
	@IdCountry	INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Currency]
				 WHERE	IdCountry = @IdCountry))
		BEGIN
			RAISERROR (N'El país cuenta con monedas. No se puede borrar.',16,1);
		END
	ELSE IF(EXISTS(	SELECT	*
					  FROM	[Customs]
					 WHERE	IdCountry = @IdCountry))
		BEGIN
			RAISERROR (N'El país cuenta con aduanas relacionadas. No se puede borrar.',16,1);
		END
	ELSE IF(EXISTS(	SELECT	*
					  FROM	[FileHeader]
					 WHERE	IdCountry = @IdCountry))
		BEGIN
			RAISERROR (N'El país cuenta con transacciones dentro del sistema. No se puede borrar.',16,1);
		END
	ELSE
		BEGIN
			DELETE FROM [Country] WHERE Id = @IdCountry;
		END