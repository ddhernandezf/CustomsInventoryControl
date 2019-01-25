CREATE PROCEDURE [dbo].[spg_DetailResponse]
	@IdOpaDetail	INT
AS
	IF EXISTS(	SELECT	*
				  FROM	[OpaDetail]
				 WHERE	Id = @IdOpaDetail)
		BEGIN
			SELECT	ResponseDate, ErrorMessage, ErrorType
			  FROM	[OpaResponse]
			 WHERE	IdOpaDetail= @IdOpaDetail
			 ORDER BY ResponseDate DESC
		END
	ELSE
		BEGIN
			SELECT	ResponseDate, ErrorMessage, ErrorType
			  FROM	[OpaResponseHist]
			 WHERE	IdOpaDetail= @IdOpaDetail
			 ORDER BY ResponseDate DESC
		END
