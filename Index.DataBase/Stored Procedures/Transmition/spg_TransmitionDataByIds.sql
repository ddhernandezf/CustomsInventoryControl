CREATE PROCEDURE [dbo].[spg_TransmitionDataByIds]
	@IdItemDischarge	VARCHAR(MAX)
AS
	DECLARE	@ItemDischargeListTable TABLE(
		[IdFileItemDischargeTemp]	INT
	)

	IF(ISNULL(@IdItemDischarge, '') <> '')
		BEGIN
			INSERT INTO @ItemDischargeListTable([IdFileItemDischargeTemp])
			SELECT Item = CONVERT(INT, Item) 
			  FROM	(	SELECT	Item = x.i.value('(./text())[1]', 'varchar(max)')
						  FROM	(	SELECT [XML] = CONVERT(XML, '<i>'
												+ REPLACE(@IdItemDischarge, ',', '</i><i>') + '</i>').query('.')
					  ) AS a CROSS APPLY [XML].nodes('i') AS x(i) 
					  ) AS y
			 WHERE Item IS NOT NULL
		END

	SELECT	fid.Id[IdFileItemDischarge], fhe.Id[IdFileHeaderSubstract], fde.Id[IdFileDetailSubstract],
			fhe.IdDocument[IdDocumentSubstract], fde.TransactionLine[TransactionLineSubstract],
			(fid.Quantity + fid.Decrease)[QuantitySubstract], fid.CIFcost[CifSubstract], fid.FOcost[FobSubstract], 
			fid.CustomDuties[CustomDutiesSubstract], fid.Iva[IvaSubstract], fhi.Id[IdFileHeaderStock], 
			fdi.Id[IdFileDetailStock], fhi.IdDocument[IdDocumentStock], fdi.TransactionLine[TransactionLineStock],
			CONCAT(fie.Name, ' (', fite.Name, ')')[DocumentNameSubstract],
			CONCAT(fii.Name, ' (', fiti.Name, ')')[DocumentNameStock],
			fhe.AuthorizationDate, fhe.RegisterDate
	  FROM	FileItemDischarge fid INNER JOIN FileDetail fde ON fid.IdFileDetailSubstract = fde.Id
									INNER JOIN FileHeader fhe ON fde.IdFileHeader = fhe.Id
									INNER JOIN FileInfoConfig fice ON fice.Id = fhe.IdFileInfoConfig
									INNER JOIN FileInfo fie ON fie.Id = fice.IdFileInfo
									INNER JOIN FileInfoType fite ON fite.Id = fice.IdFileType
									INNER JOIN FileDetail fdi ON fid.IdFileDetailStock = fdi.Id
									INNER JOIN FileHeader fhi ON fdi.IdFileHeader = fhi.Id
									INNER JOIN FileInfoConfig fici ON fici.Id = fhi.IdFileInfoConfig
									INNER JOIN FileInfo fii ON fii.Id = fici.IdFileInfo
									INNER JOIN FileInfoType fiti ON fiti.Id = fici.IdFileType
									INNER JOIN @ItemDischargeListTable t ON t.IdFileItemDischargeTemp = fid.Id
