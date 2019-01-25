CREATE PROCEDURE [dbo].[spg_FileItemDischarge]
	@IdFileItemDischarge	INT,
	@IdFileHeader			INT,
	@IdFileDetail			INT,
	@IdItem					INT
AS
	IF(ISNULL(@IdFileItemDischarge, 0) = 0)
		BEGIN
			IF(ISNULL(@IdFileHeader, 0) = 0)
				BEGIN
					IF(ISNULL(@IdFileDetail, 0) = 0)
						BEGIN
							IF(ISNULL(@IdItem, 0) = 0)
								BEGIN
									SELECT	fid.Id[IdFileItemDischarge], fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity,
											fid.Decrease, fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva
									  FROM	[FileItemDischarge] fid
								END
							ELSE
								BEGIN
									SELECT	fid.Id[IdFileItemDischarge], fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity,
											fid.Decrease, fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fd ON fd.Id = fid.IdFileDetailSubstract
									 WHERE	fd.IdItem = @IdItem
								END
						END
					ELSE
						BEGIN
							IF(ISNULL(@IdItem, 0) = 0)
								BEGIN
									SELECT	fid.Id[IdFileItemDischarge], fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity,
											fid.Decrease, fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva
									  FROM	[FileItemDischarge] fid
									 WHERE	fid.IdFileDetailSubstract = @IdFileDetail
								END
							ELSE
								BEGIN
									SELECT	fid.Id[IdFileItemDischarge], fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity,
											fid.Decrease, fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fd ON fd.Id = fid.IdFileDetailSubstract
									 WHERE	fd.IdItem = @IdItem
									   AND	fid.IdFileDetailSubstract = @IdFileDetail
								END
						END
				END
			ELSE
				BEGIN
					IF(ISNULL(@IdFileDetail, 0) = 0)
						BEGIN
							IF(ISNULL(@IdItem, 0) = 0)
								BEGIN
									SELECT	fid.Id[IdFileItemDischarge], fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity,
											fid.Decrease, fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fd ON fd.Id = fid.IdFileDetailSubstract
									 WHERE	fd.IdFileHeader = @IdFileHeader
								END
							ELSE
								BEGIN
									SELECT	fid.Id[IdFileItemDischarge], fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity,
											fid.Decrease, fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fd ON fd.Id = fid.IdFileDetailSubstract
									 WHERE	fd.IdFileHeader = @IdFileHeader
									   AND	fd.IdItem = @IdItem
								END
						END
					ELSE
						BEGIN
							IF(ISNULL(@IdItem, 0) = 0)
								BEGIN
									SELECT	fid.Id[IdFileItemDischarge], fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity,
											fid.Decrease, fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fd ON fd.Id = fid.IdFileDetailSubstract
									 WHERE	fd.IdFileHeader = @IdFileHeader
									   AND	fd.Id = @IdFileDetail
								END
							ELSE
								BEGIN
									SELECT	fid.Id[IdFileItemDischarge], fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity,
											fid.Decrease, fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva
									  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fd ON fd.Id = fid.IdFileDetailSubstract
									 WHERE	fd.IdFileHeader = @IdFileHeader
									   AND	fd.Id = @IdFileDetail
									   AND	fd.IdItem = @IdItem
								END
						END
				END
		END
	ELSE
		BEGIN
			SELECT	fid.Id[IdFileItemDischarge], fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, fid.Quantity,
					fid.Decrease, fid.CIFcost, fid.FOcost, fid.CustomDuties, fid.Iva
			  FROM	[FileItemDischarge] fid
			 WHERE	fid.Id = @IdFileItemDischarge
		END