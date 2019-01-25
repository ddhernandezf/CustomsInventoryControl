BEGIN TRAN;

DECLARE @StateTransmited INT = (SELECT Id FROM [State] WHERE [Name] = 'Transmitido');

UPDATE	FileItemDischarge
   SET	IdState = @StateTransmited
 WHERE	Id IN (	SELECT	DISTINCT fid.Id
				  FROM	[OpaResponseHist] orh INNER JOIN [OpaDetailHist] odh ON orh.IdOpaDetail = odh.Id
											  INNER JOIN [FileItemDischarge] fid ON fid.Id = odh.IdFileItemDischarge
				 WHERE	TransactionNumber IS NOT NULL
				   AND	TransactionNumber > 0);