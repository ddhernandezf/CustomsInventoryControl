CREATE PROCEDURE [dbo].[spg_CustomerDischarged]
	@IdCustomer	INT
AS
	IF(ISNULL(@IdCustomer, 0) = 0)
		BEGIN
			SELECT	c.IdPerson, p.FirstName + ' ' + p.LastName [Name], p.Nit, c.LegalRepresentative, c.PersonCode, c.ImporterCode, 
					c.ExporterCode, c.ResolutionRate, c.RegimeRate, c.FiscalPeriod, c.ResolutionStartDate, c.ResolutionEndDate, 
					c.Observations, p.FirstName, p.LastName, p.EnterpriseName
			  FROM	[Customer] c INNER JOIN	[Person] p ON c.IdPerson = p.Id
										 INNER JOIN [CustomerDischarge] cd ON c.IdPerson = cd.IdCustomer
		END
	ELSE
		BEGIN
			SELECT	c.IdPerson, p.FirstName + ' ' + p.LastName [Name], p.Nit, c.LegalRepresentative, c.PersonCode, c.ImporterCode, 
					c.ExporterCode, c.ResolutionRate, c.RegimeRate, c.FiscalPeriod, c.ResolutionStartDate, c.ResolutionEndDate, 
					c.Observations, p.FirstName, p.LastName, p.EnterpriseName
			  FROM	[Customer] c INNER JOIN	[Person] p ON c.IdPerson = p.Id
										 INNER JOIN [CustomerDischarge] cd ON c.IdPerson = cd.IdCustomer
			 WHERE	c.IdPerson = @IdCustomer
		END
