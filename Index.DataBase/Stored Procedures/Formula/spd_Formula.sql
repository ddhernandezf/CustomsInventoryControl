CREATE PROCEDURE [dbo].[spd_Formula]
	@Id			INT
AS
	--DECLARE @IdMainItem	INT, @IdDetailItem;
	--SELECT @IdMainItem = IdMainItem FROM Formula WHERE Id = 1

	--IF EXISTS(	SELECT	*
	--			  FROM	[FileDetail]
	--			 WHERE	IdItem = @IdMainItem)
	--	BEGIN
	--		RAISERROR (N'La materia prima seleccionada ya contiene registro de movimientos. No se puede borrar.',16,1);
	--	END
	--ELSE
	--	BEGIN
	--		DELETE FROM [Formula] WHERE Id = @Id;
	--	END
	DELETE FROM Formula where Id = @id;
