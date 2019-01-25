CREATE PROCEDURE [dbo].[spd_Item]
	@Id	INT
AS
	DECLARE @IsProduct	BIT;
	SELECT @IsProduct = IsProduct FROM [Item] WHERE Id = @Id;
	
	IF(EXISTS(SELECT * FROM	[FileDetail] WHERE IdItem = @Id))
		BEGIN
			IF(@IsProduct = 1)
				BEGIN
					RAISERROR (N'El producto contiene movimientos. No se puede borrar.',16,1);
				END
			ELSE
				BEGIN
					RAISERROR (N'La materia prima contiene movimientos. No se puede borrar.',16,1);
				END
		END
	ELSE IF EXISTS(SELECT * FROM Formula WHERE IdMainItem = @Id OR IdDetailItem = @Id)
	BEGIN
		IF(@IsProduct = 1)
			BEGIN
				RAISERROR (N'El producto contiene una formula. No se puede borrar.',16,1);
			END
		ELSE
			BEGIN
				RAISERROR (N'La materia prima es parte de una formula. No se puede borrar.',16,1);
			END
	END
	ELSE
		BEGIN
			DELETE FROM [Item] WHERE Id = @Id;
		END