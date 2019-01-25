CREATE PROCEDURE [dbo].[spg_DashboardCustomer]
	@IdCustomer	INT
AS
	DECLARE	@DaysToExpire	INT
	SELECT @DaysToExpire = DaysToExpire FROM [Parameters];
	
	SELECT	IdPerson, BondEndDate,
			DATEDIFF(DAY, GETDATE(), BondEndDate)[Days],
			CASE WHEN DATEDIFF(DAY, GETDATE(), BondEndDate) > @DaysToExpire THEN 'En tiempo'
				 WHEN DATEDIFF(DAY, GETDATE(), BondEndDate) BETWEEN 1 AND @DaysToExpire THEN  'Por expirar'
				 WHEN DATEDIFF(DAY, GETDATE(), BondEndDate) < 0 THEN 'Expirado'
				ELSE 'No se han fijado las fechas de resolución'
			END[Label]
	  FROM	[Customer]
	 WHERE	IdPerson = @IdCustomer