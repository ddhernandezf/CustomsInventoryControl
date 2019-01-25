CREATE PROCEDURE [dbo].[spg_DischargeDetailResumeCounter]
	@IdFileDetail	INT
AS
	SELECT	COUNT(*)[Counter]
	  FROM	[FileItemDischarge] fid INNER JOIN [FileDetail] fd ON fid.IdFileDetailStock = fd.Id
									INNER JOIN [FileHeader] fh ON fh.Id = fd.IdFileHeader
	 WHERE	IdFileDetailSubstract = @IdFileDetail;