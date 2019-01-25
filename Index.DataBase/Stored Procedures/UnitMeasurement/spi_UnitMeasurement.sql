CREATE PROCEDURE [dbo].[spi_UnitMeasurement]
	@Name			VARCHAR(150), 
	@Description	VARCHAR(1000),
	@Symbol			VARCHAR(4),
	@RegisterUser	VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[UnitMeasurement]
				 WHERE	UPPER(Name) = UPPER(@Name)))
		BEGIN
			RAISERROR (N'La unidad de medida %s ya se encuentra registrada.',16,1, @Name);
		END
	ELSE
		BEGIN
			INSERT INTO [UnitMeasurement](Name, [Description], Symbol, RegisterDate, RegisterUser)
			VALUES(@Name, @Description, @Symbol, GETDATE(), @RegisterUser);
		END
