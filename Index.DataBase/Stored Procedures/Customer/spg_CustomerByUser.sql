CREATE PROCEDURE [dbo].[spg_CustomerByUser]
	@IdCustomer		INT,
	@UserName		VARCHAR(60)
AS
	IF(ISNULL(@IdCustomer,0) = 0)
		BEGIN
			IF(ISNULL(@UserName,'') = '')
				BEGIN
					SELECT	c.IdPerson, p.FirstName + ' ' + p.LastName [Name], p.Nit, c.LegalRepresentative, c.PersonCode, c.ImporterCode, 
							c.ExporterCode, c.Observations,p.FirstName, p.LastName, p.EnterpriseName, c.BondEndDate
					  FROM	[Customer] c INNER JOIN	[Person] p ON c.IdPerson = p.Id
										 INNER JOIN [CustomerUser] cu ON c.IdPerson = cu.IdCustomer
				END
			ELSE
				BEGIN
					SELECT	c.IdPerson, p.FirstName + ' ' + p.LastName [Name], p.Nit, c.LegalRepresentative, c.PersonCode, c.ImporterCode, 
							c.ExporterCode, c.Observations,p.FirstName, p.LastName, p.EnterpriseName, c.BondEndDate
					  FROM	[Customer] c INNER JOIN	[Person] p ON c.IdPerson = p.Id
										 INNER JOIN [CustomerUser] cu ON c.IdPerson = cu.IdCustomer
					 WHERE	cu.UserName = @UserName
			END
		END
	ELSE
		BEGIN
			IF(ISNULL(@UserName,'') = '')
				BEGIN
					SELECT	c.IdPerson, p.FirstName + ' ' + p.LastName [Name], p.Nit, c.LegalRepresentative, c.PersonCode, c.ImporterCode, 
							c.ExporterCode, c.Observations,p.FirstName, p.LastName, p.EnterpriseName, c.BondEndDate
					  FROM	[Customer] c INNER JOIN	[Person] p ON c.IdPerson = p.Id
										 INNER JOIN [CustomerUser] cu ON c.IdPerson = cu.IdCustomer
					 WHERE	c.IdPerson = @IdCustomer
				END
			ELSE
				BEGIN
					SELECT	c.IdPerson, p.FirstName + ' ' + p.LastName [Name], p.Nit, c.LegalRepresentative, c.PersonCode, c.ImporterCode, 
							c.ExporterCode, c.Observations,p.FirstName, p.LastName, p.EnterpriseName, c.BondEndDate
					  FROM	[Customer] c INNER JOIN	[Person] p ON c.IdPerson = p.Id
										 INNER JOIN [CustomerUser] cu ON c.IdPerson = cu.IdCustomer
					 WHERE	cu.UserName = @UserName
					   AND	c.IdPerson = @IdCustomer
			END
		END
