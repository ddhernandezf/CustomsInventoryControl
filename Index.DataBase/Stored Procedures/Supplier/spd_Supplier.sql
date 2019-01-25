CREATE PROCEDURE [dbo].[spd_Supplier]
	@IdPerson INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[FileAttached]
				 WHERE	IdSupplier = @IdPerson))
	BEGIN
		RAISERROR (N'El proveedor cuenta con transacciones dentro del sistema. No se puede borrar.',16,1);
	END
	ELSE
	BEGIN
		DELETE FROM [Supplier] WHERE IdPerson = @IdPerson;
		DELETE FROM [Phone] where IdPerson = @IdPerson;
		DELETE FROM [Email] where IdPerson = @IdPerson;
		DELETE FROM [Address] where IdPerson = @IdPerson;
		DELETE FROM [Person] WHERE Id = @IdPerson;
	END