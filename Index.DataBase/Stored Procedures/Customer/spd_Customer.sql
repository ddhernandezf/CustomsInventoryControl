CREATE PROCEDURE [dbo].[spd_Customer]
	@IdCustomer		INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[CustomerAccount]
				 WHERE	IdCustomer = @IdCustomer))
		BEGIN
			RAISERROR (N'El cliente tiene cuentas asignadas. No se puede borrar.',16,1);
		END
	ELSE IF(EXISTS(	SELECT	*
					  FROM	[CustomerUser]
					 WHERE	IdCustomer = @IdCustomer))
		BEGIN
			RAISERROR (N'El cliente se encuentra asignado a un usuario. No se puede borrar.',16,1);
		END
	ELSE IF(EXISTS(	SELECT	*
					  FROM	[FileHeader]
					 WHERE	IdCustomer = @IdCustomer))
		BEGIN
			RAISERROR (N'El cliente cuenta con transacciones dentro del sistema. No se puede borrar.',16,1);
		END
	ELSE IF(EXISTS(	SELECT	*
					  FROM	[Resolution]
					 WHERE	IdCustomer = @IdCustomer))
		BEGIN
			RAISERROR (N'El cliente cuenta con resoluciones. No se puede borrar.',16,1);
		END
	ELSE
		BEGIN
			DELETE FROM [CustomerDischarge] WHERE IdCustomer = @IdCustomer;
			DELETE FROM [Customer] WHERE IdPerson = @IdCustomer;
			DELETE FROM [Phone] WHERE IdPerson = @IdCustomer;
			DELETE FROM [Email] WHERE IdPerson = @IdCustomer;
			DELETE FROM [Address] WHERE IdPerson = @IdCustomer;
			DELETE FROM [Person] WHERE Id = @IdCustomer;
		END
	
