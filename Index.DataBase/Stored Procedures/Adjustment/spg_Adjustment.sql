CREATE PROCEDURE [dbo].[spg_Adjustment]
	@IdFileDetailStock	INT,
	@IdFileDetailSubstract	INT
AS
	SELECT	fid.Id[IdFileItemDischarge], fid.IdFileDetailSubstract, fid.IdFileDetailStock, fid.IdState, s.[Name][StateName],
			fdi.IdItem, fid.Quantity, fid.Decrease, fid.RegisterDate
	  FROM	FileItemDischarge fid INNER JOIN FileDetail fdi ON fdi.Id = fid.IdFileDetailStock
								  INNER JOIN [State] s ON s.Id = fid.IdState
	 WHERE	IdFileDetailStock = @IdFileDetailStock
	   AND	IdFileDetailSubstract = @IdFileDetailSubstract