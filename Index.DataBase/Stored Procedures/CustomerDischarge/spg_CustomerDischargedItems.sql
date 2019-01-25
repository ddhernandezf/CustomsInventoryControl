CREATE PROCEDURE [dbo].[spg_CustomerDischargedItems]
	@IdCustomer	INT
AS
	SELECT	Id,IdCustomer, FilePath, DocumentName, DocumentDescription
	  FROM	CustomerDischarge
	 WHERE	IdCustomer = IdCustomer