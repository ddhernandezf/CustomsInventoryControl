CREATE PROCEDURE [dbo].[spd_Customs]
	@IdCustom	INT
AS
	IF(EXISTS(	SELECT	*
				  FROM	[FileHeader]
				 WHERE	IdCustom = @IdCustom))
		BEGIN
			RAISERROR (N'La aduana cuenta con transacciones dentro del sistema. No se puede borrar.',16,1);
		END
	ELSE 
		BEGIN
			DELETE FROM [Customs] WHERE Id = @IdCustom;
		END