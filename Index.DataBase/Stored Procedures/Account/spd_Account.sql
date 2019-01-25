CREATE PROCEDURE [dbo].[spd_Account]
	@Id	INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[CustomerAccount]
				 WHERE IdAccount = @Id))
		BEGIN
			RAISERROR (N'La cuenta se encuentra asignada a clientes. No se puede borrar.',16,1);
		END
	ELSE IF(EXISTS(	SELECT	*
					  FROM	[FileInfoConfig]
					 WHERE IdAccount = @Id))
		BEGIN
			RAISERROR (N'La cuenta tiene transacciones en el sistema. No se puede borrar.',16,1);
		END
	ELSE IF(EXISTS(	SELECT	*
					  FROM	[FileHeader]
					 WHERE IdAccount = @Id))
		BEGIN
			RAISERROR (N'La cuenta tiene transacciones en el sistema. No se puede borrar.',16,1);
		END
	ELSE IF(EXISTS(	SELECT	*
					  FROM	[Resolution]
					 WHERE IdAccount = @Id))
		BEGIN
			RAISERROR (N'La cuenta se encuentra asignada a resoluciones. No se puede borrar.',16,1);
		END
	ELSE
		BEGIN
			DELETE FROM [Account] WHERE Id = @Id;
		END
