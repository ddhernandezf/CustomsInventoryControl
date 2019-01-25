CREATE PROCEDURE [dbo].[spd_Currency]
	@Id	INT
AS
	IF EXISTS(	SELECT	*
				  FROM	[FileHeader]
				 WHERE	IdCurrency = @Id)
		BEGIN
			RAISERROR (N'La moneda cuenta con información relacionada en los diferentes documentos de transacciones del sistema. No puede ser eliminada.',16,1);
		END
	ELSE IF EXISTS(	SELECT	*
				  FROM	[Parameters]
				 WHERE	DefaultCurrency = @Id)
		BEGIN
			RAISERROR (N'La moneda se encuentra relacionada con los parámetros generales del sistema. No puede ser eliminada.',16,1);
		END
	ELSE
		BEGIN
			DELETE FROM [Currency] WHERE Id = @Id;
		END
