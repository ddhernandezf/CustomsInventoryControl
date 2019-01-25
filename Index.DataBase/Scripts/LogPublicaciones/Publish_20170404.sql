DECLARE	@Dua			INT,
		@Fauca			INT,
		@Poliza			INT,
		@Exportacion	INT,
		@2989			INT;

SELECT @Dua = Id FROM [FileInfo] WHERE [Name] = 'DUA';
SELECT @Fauca = Id FROM [FileInfo] WHERE [Name] = 'FAUCA';
SELECT @Poliza = Id FROM [FileInfo] WHERE [Name] = 'Póliza';
SELECT @Exportacion = Id FROM [FileInfoType] WHERE [Name] = 'Exportación'
SELECT @2989 = Id FROM Account WHERE [Name] = 'Cta cte 2989'

UPDATE	[FileInfoConfig]
   SET	Transmissible = 1
 WHERE	IdFileInfo = @Dua
   AND	IdFileType = @Exportacion
   AND	IdAccount = @2989;

UPDATE	[FileInfoConfig]
   SET	Transmissible = 1
 WHERE	IdFileInfo = @Fauca
   AND	IdFileType = @Exportacion
   AND	IdAccount = @2989;

UPDATE	[FileInfoConfig]
   SET	Transmissible = 1
 WHERE	IdFileInfo = @Poliza
   AND	IdFileType = @Exportacion
   AND	IdAccount = @2989;