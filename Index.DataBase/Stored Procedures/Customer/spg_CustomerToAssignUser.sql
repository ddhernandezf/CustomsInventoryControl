CREATE PROCEDURE [spg_CustomerToAssignUser]
	@UserName	VARCHAR(60)
AS
	DECLARE @TempData TABLE (
		[IdCustomer] INT NOT NULL, 
		[Name] VARCHAR(400) NOT NULL
	)

	DECLARE @TempDataFinal TABLE (
		[IdCustomer] INT NOT NULL, 
		[Name] VARCHAR(400) NOT NULL,
		[IsAssigned] BIT NOT NULL
	)

	INSERT INTO @TempData(IdCustomer, [Name])
	SELECT	c.IdPerson,
			CASE 
				WHEN p.IsEnterprise = 1 THEN p.EnterpriseName
				ELSE
					case when p.LastName is null 
						then p.FirstName
						else p.FirstName + ' ' + p.LastName
					end
			END [Name]
	  FROM	[Customer] c INNER JOIN [Person] p ON p.Id = c.IdPerson

	INSERT INTO @TempDataFinal(IdCustomer, [Name], IsAssigned)
	SELECT	IdCustomer, [Name], 1[IsAssigned]
	  FROM	@TempData
	 WHERE	IdCustomer IN (	SELECT	IdCustomer
							  FROM	[CustomerUser]
							 WHERE	UserName = @UserName)

	INSERT INTO @TempDataFinal(IdCustomer, [Name], IsAssigned)
	SELECT	IdCustomer, [Name], 0[IsAssigned]
	  FROM	@TempData
	 WHERE	IdCustomer NOT IN (	SELECT	IdCustomer
								  FROM	[CustomerUser]
								 WHERE	UserName = @UserName)

	SELECT	IdCustomer, [Name], IsAssigned
	  FROM	@TempDataFinal