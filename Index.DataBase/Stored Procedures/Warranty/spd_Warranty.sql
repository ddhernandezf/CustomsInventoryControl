CREATE PROCEDURE [dbo].[spd_Warranty]
	@Id	INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[FileHeader]
				 WHERE IdWarranty = @Id))
		BEGIN
			RAISERROR (N'La garantía contiene registros en diferentes documentos. No puede ser borrada.',16,1);
		END
	ELSE
		BEGIN
			DELETE FROM [Warranty] WHERE Id = @Id;
		END;