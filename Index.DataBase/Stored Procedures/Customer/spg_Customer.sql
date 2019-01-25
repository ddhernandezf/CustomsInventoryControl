CREATE PROCEDURE [dbo].[spg_Customer]
	@IdCustomer		INT,
	@IsEnterPrise	BIT
AS
	IF(ISNULL(@IdCustomer,0) = 0)
		BEGIN
			SELECT	c.IdPerson, p.EnterpriseName [Name],p.Nit, c.LegalRepresentative, c.PersonCode, c.ImporterCode, c.ExporterCode, 
					c.Observations,	p.FirstName, p.LastName, c.BondEndDate
			 FROM	[Customer] c INNER JOIN	[Person] p ON c.IdPerson = p.Id
			 WHERE	p.IsEnterprise = @IsEnterPrise
		END
	ELSE
		BEGIN
			SELECT	c.IdPerson, p.EnterpriseName [Name],p.Nit, c.LegalRepresentative, c.PersonCode, c.ImporterCode, c.ExporterCode, 
					c.Observations,	p.FirstName, p.LastName, c.BondEndDate
			 FROM	[Customer] c INNER JOIN	[Person] p ON c.IdPerson = p.Id
			 WHERE	p.IsEnterprise = @IsEnterPrise
			   AND	c.IdPerson = @IdCustomer
		END
