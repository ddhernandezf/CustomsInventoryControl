CREATE PROCEDURE [spu_FileAttached]
	@IdFileAttached	INT,
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
			IF EXISTS(	SELECT	*
						  FROM	[FileAttached]
						 WHERE	IdFileHeader = @IdFileHeader
						   AND	IdSupplier = @IdSupplier
						   AND	AttachedNumber = @AttachedNumber
						   AND	Id <> @IdFileAttached)
				BEGIN
					RAISERROR (N'Este registro ya existe dentro de la información.',16,1);
				END
			ELSE
				BEGIN
					UPDATE	[FileAttached] 
					   SET	IdFileHeader = @IdFileHeader, 
							IdSupplier = @IdSupplier,
							[Description] = @Description, 
							AttachedNumber = @AttachedNumber, 
							AttachedDate = @AttachedDate, 
							RegisterDate = GETDATE(), 
							RegisterUser = @RegisterUser
					 WHERE	Id = @IdFileAttached;
				END
		END
	ELSE
		BEGIN
			RAISERROR (N'El documento ya se encuentra revisado, por lo tanto no se pueden realizar modificaciones.',16,1);
		END