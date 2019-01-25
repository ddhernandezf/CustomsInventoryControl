CREATE PROCEDURE [dbo].[spd_FileHeader]
	@Id	INT
AS
	DECLARE	@State VARCHAR(100)
	
	SELECT	@State = UPPER(s.Name)
	  FROM	[FileHeader] f INNER JOIN [State] s ON s.Id = f.IdState
	 WHERE	f.Id = @Id
	
	DECLARE	@UseAttached BIT;
	SELECT	@UseAttached = fic.UseAttached
	  FROM	FileHeader fh INNER JOIN FileInfoConfig fic ON fic.Id = fh.IdFileInfoConfig
	 WHERE	fh.Id = @Id

	IF(@UseAttached = 0)
		BEGIN
			DELETE FROM FileAttached WHERE IdFileHeader = @Id;
		END

	IF(@State = 'INGRESADO')
	BEGIN
		DELETE FROM [FileHeader] WHERE Id = @Id;
	END
	ELSE
	BEGIN
		DECLARE	@CounterDetail		INT = (SELECT COUNT(*) FROM [FileDetail] WHERE IdFileHeader = @Id),
				@CounterAttached	INT = (SELECT COUNT(*) FROM [FileAttached] WHERE IdFileHeader = @Id);

		IF(@CounterAttached = 0 AND @CounterDetail = 0)
			BEGIN
				DELETE FROM [FileHeader] WHERE Id = @Id;
			END
		ELSE
			BEGIN
				IF(@CounterAttached > 0 AND @CounterDetail > 0)
					BEGIN
						RAISERROR (N'El documento ya cuenta con información registrada. No puede ser eliminado.',16,1);
					END
				ELSE IF(@CounterAttached = 0 AND @CounterDetail > 0)
					BEGIN
						RAISERROR (N'El documento aun cuenta con información en su detalle. No puede ser eliminado.',16,1);
					END
				ELSE IF(@CounterAttached > 0 AND @CounterDetail = 0)
					BEGIN
						RAISERROR (N'El documento aun cuenta con información de documentos adjuntos. No puede ser eliminado.',16,1);
					END
			END
	END
