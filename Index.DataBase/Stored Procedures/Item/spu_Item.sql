CREATE PROCEDURE [dbo].[spu_Item]
	@Id					INT,
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
				   AND	IdAccount = @IdAccount
				   AND	Name = @Name
				   AND	IsProduct = @IsProduct
				   AND	Code = @Code
				   AND	IdUnitMeasurement = @IdUnitMeasurement
				   AND	Id <> @Id))
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
			UPDATE	[Item]
			   SET	IdCustomer = @IdCustomer,
					IdAccount = @IdAccount,
					IdUnitMeasurement = @IdUnitMeasurement,
					IdResolution = @IdResolution,
					IdAccountingItem = @IdAccountingItem,
					Name = @Name, 
					[Description] = @Description,
					Code = @Code,  
					Barcode = @Barcode, 
					IsProduct = @IsProduct,
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser,
					Active = @Active
			 WHERE	Id = @Id;

			 IF(@IsProduct = 0)
				 BEGIN
					UPDATE	Formula
					   SET	Active = @Active
					 WHERE	IdDetailItem = @Id;
				 END
		END
