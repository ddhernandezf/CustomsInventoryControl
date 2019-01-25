CREATE PROCEDURE [dbo].[spi_Item]
	@IdCustomer			INT,
	@IdAccount			INT,
	@IdUnitMeasurement	INT,
	@IdResolution		INT,
	@IdAccountingItem	INT,
	@Code				NVARCHAR(50),
	@Name				VARCHAR(200),
	@Description		VARCHAR(1000),
	@Barcode			NVARCHAR(100),
	@IsProduct			BIT,
	@Active				BIT,
	@RegisterUser		VARCHAR(60)
AS
	IF(EXISTS(	SELECT	*
				  FROM	[Item]
				 WHERE	IdCustomer = @IdCustomer
				   AND	Name = @Name
				   AND	IdUnitMeasurement = @IdUnitMeasurement
				   AND	IsProduct = @IsProduct))
	BEGIN
		IF(@IsProduct = 1)
			BEGIN
				RAISERROR (N'El producto %s ya se encuentra registrado.',16,1, @Name);
			END
		ELSE
			BEGIN
				RAISERROR (N'La materia prima %s ya se encuentra registrada.',16,1, @Name);
			END
	END
	ELSE
		BEGIN
			INSERT INTO [Item](IdCustomer, IdAccount, IdUnitMeasurement, IdResolution, IdAccountingItem, Name, [Description], 
							Code, Barcode, IsProduct, RegisterDate, RegisterUser, Active)
			VALUES (@IdCustomer, @IdAccount, @IdUnitMeasurement, @IdResolution, @IdAccountingItem, @Name, @Description, 
					@Code, @Barcode, @IsProduct, GETDATE(), @RegisterUser, @Active);
		END