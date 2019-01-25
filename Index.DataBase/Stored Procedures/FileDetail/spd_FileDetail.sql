CREATE PROCEDURE [spd_FileDetail]
	@IdFileDetail	INT
AS
	DECLARE	@State			VARCHAR(100),
			@IdFileHeader		INT,
			@LastStock			INT,
			@IdItem				INT,
			@IsSubstract		BIT,
			@LoadRawMaterial	BIT,
			@IdCustomer			INT,
			@IdAccount			INT
	
	SELECT	@State = UPPER(s.Name), @IsSubstract = fic.IsSubstract, @LoadRawMaterial = fic.LoadRawMaterial, @IdCustomer = fh.IdCustomer,
			@IdAccount = fh.IdAccount, @LastStock = fd.ItemQuantity, @IdFileHeader = fd.IdFileHeader, @IdItem = fd.IdItem
	  FROM	[FileDetail] fd INNER JOIN [FileHeader] fh ON fh.Id = fd.IdFileHeader
							INNER JOIN [State] s ON s.Id = fh.IdState
							INNER JOIN [FileInfoConfig] fic ON fh.IdFileInfoConfig = fic.Id
	 WHERE	fd.Id = @IdFileDetail

	IF(@State <> 'REVISADO')
		BEGIN
			IF EXISTS(	SELECT	*
						  FROM	[ItemInventory]
						 WHERE	IdCustomer = @IdCustomer
						   AND	IdAccount = @IdAccount
						   AND	IdFileHeader = @IdFileHeader
						   AND	IdFileDetail = @IdFileDetail
						   AND	IdItem = @IdItem)
				BEGIN
					IF(@IsSubstract = 0)
						BEGIN
							DELETE FROM [ItemInventory]
							 WHERE	IdCustomer = @IdCustomer
							   AND	IdAccount = @IdAccount
							   AND	IdFileHeader = @IdFileHeader
							   AND	IdFileDetail = @IdFileDetail
							   AND	IdItem = @IdItem;
						END
				END

			DELETE FROM [FileDetail] WHERE Id = @IdFileDetail;
		END
	ELSE
		BEGIN
			RAISERROR (N'El documento ya se encuentra revisado, por lo tanto no se pueden realizar modificaciones.',16,1);
		END