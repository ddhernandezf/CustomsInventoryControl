CREATE PROCEDURE [spi_FileAttached]
	@IdFileHeader	INT,
	@IdSupplier		INT,
	@Description	VARCHAR(300),
	@AttachedNumber	VARCHAR(100),
	@AttachedDate	DATETIME,
	@RegisterUser	VARCHAR(60)
AS
	DECLARE	@State VARCHAR(100)

	SELECT	@State = UPPER(s.Name)
	  FROM	[FileHeader] f INNER JOIN [State] s ON s.Id = f.IdState
	 WHERE	f.Id = @IdFileHeader
	
	IF(@State <> 'REVISADO')
		BEGIN
			DECLARE	@IdStateIngresado	INT,
					@IdStateGrabado		INT,
					@TransactionLine	INT
			
			SELECT @IdStateIngresado = Id FROM [State] WHERE [Name] = 'Ingresado'
			SELECT @IdStateGrabado = Id FROM [State] WHERE [Name] = 'Grabado'
			SELECT @TransactionLine = COUNT(*) FROM [FileDetail] WHERE IdFileHeader = @IdFileHeader
	
			IF EXISTS(	SELECT	*
						  FROM [FileHeader] fh INNER JOIN [State] s ON s.Id = fh.IdState
						 WHERE	fh.id = @IdFileHeader
						   AND	s.[Name] = 'Ingresado')
			BEGIN
				UPDATE [FileHeader] SET IdState = @IdStateGrabado WHERE Id = @IdFileHeader
			END

			IF EXISTS(	SELECT	*
						  FROM	[FileAttached]
						 WHERE	IdFileHeader = @IdFileHeader
						   AND	IdSupplier = @IdSupplier
						   AND	AttachedNumber = @AttachedNumber)
				BEGIN
					RAISERROR (N'Este registro ya existe dentro de la información.',16,1);
				END
			ELSE
				BEGIN
					INSERT INTO [FileAttached] (IdFileHeader, IdSupplier, [Description], AttachedNumber, AttachedDate,
												RegisterDate, RegisterUser)
					VALUES(@IdFileHeader, @IdSupplier, @Description, @AttachedNumber, @AttachedDate,
							GETDATE(), @RegisterUser);
				END
		END
	ELSE
		BEGIN
			RAISERROR (N'El documento ya se encuentra revisado, por lo tanto no se pueden realizar modificaciones.',16,1);
		END