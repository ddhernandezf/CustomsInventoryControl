CREATE PROCEDURE [dbo].[spg_OpaHeader]
	@IdCustomer		INT,
	@IdAccount		INT, 
	@IdOpaHeader	INT,
	@IdState		INT,
	@UserName		VARCHAR(60)
AS
	DECLARE @IdStateTransmited	INT;
	SELECT @IdStateTransmited = Id FROM [State] WHERE [Name] = 'Transmitido';

	IF(ISNULL(@IdOpaHeader, 0) = 0)
		BEGIN
			IF(ISNULL(@IdState, 0) = 0)
				BEGIN
					SELECT	oh.Id[IdOpaHeader], UserName, IdCustomer, 
							CASE WHEN p.IsEnterprise = 1
								THEN p.EnterpriseName
								ELSE CASE WHEN p.LastName IS NULL
									THEN p.FirstName
									ELSE CONCAT(p.FirstName, ' ', p.LastName)
								END
							END[CustomerName], IdAccount, IdPriority, pr.[Name][PriorityName], oh.IdState, s.[Name][StateName],
							StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
							oh.EndDate, oh.RegisterUser, oh.RegisterDate, 
							CONCAT(dbo.fncg_Transmited(oh.Id), '/', COUNT(od.Id))[TransmitedLabel], dbo.fncg_Transmited(oh.Id)[Transmited]
					  FROM	OpaHeader oh INNER JOIN OpaDetail od ON oh.Id = od.IdOpaHeader
										 INNER JOIN [Customer] c ON oh.IdCustomer = c.IdPerson
										 INNER JOIN [Person] p ON c.IdPerson = p.Id
										 INNER JOIN [Priority] pr ON oh.IdPriority = pr.Id
										 INNER JOIN [State] s ON oh.IdState = s.Id
					 WHERE	oh.IdState NOT IN (	SELECT	Id
												  FROM	[State]
												 WHERE	Name IN ('Ingresado',
																	'Grabado',
																	'Revisado',
																	'Transmitido',
																	'Finalizado'))
					   AND	oh.UserName = @UserName
					   AND	oh.IdCustomer = @IdCustomer
					 GROUP BY oh.Id, UserName, IdCustomer, 
							CASE WHEN p.IsEnterprise = 1
								THEN p.EnterpriseName
								ELSE CASE WHEN p.LastName IS NULL
									THEN p.FirstName
									ELSE CONCAT(p.FirstName, ' ', p.LastName)
								END
							END, IdAccount, IdPriority, pr.[Name], oh.IdState, s.[Name],
							StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
							oh.EndDate, oh.RegisterUser, oh.RegisterDate
				END
			ELSE
				BEGIN
					IF(@IdStateTransmited = @IdState)
						BEGIN
							SELECT	oh.Id[IdOpaHeader], UserName, IdCustomer, 
									CASE WHEN p.IsEnterprise = 1
										THEN p.EnterpriseName
										ELSE CASE WHEN p.LastName IS NULL
											THEN p.FirstName
											ELSE CONCAT(p.FirstName, ' ', p.LastName)
										END
									END[CustomerName], IdAccount, IdPriority, pr.[Name][PriorityName], oh.IdState, s.[Name][StateName],
									StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
									oh.EndDate, oh.RegisterUser, oh.RegisterDate, 
									CONCAT(dbo.fncg_Transmited(oh.Id), '/', COUNT(od.Id))[TransmitedLabel], dbo.fncg_Transmited(oh.Id)[Transmited]
							  FROM	OpaHeader oh INNER JOIN OpaDetailHist od ON oh.Id = od.IdOpaHeader
												 INNER JOIN [Customer] c ON oh.IdCustomer = c.IdPerson
												 INNER JOIN [Person] p ON c.IdPerson = p.Id
												 INNER JOIN [Priority] pr ON oh.IdPriority = pr.Id
												 INNER JOIN [State] s ON oh.IdState = s.Id
							 WHERE	oh.IdState = @IdStateTransmited
							   AND	oh.UserName = @UserName
							   AND	oh.IdCustomer = @IdCustomer
							 GROUP BY oh.Id, UserName, IdCustomer, 
									CASE WHEN p.IsEnterprise = 1
										THEN p.EnterpriseName
										ELSE CASE WHEN p.LastName IS NULL
											THEN p.FirstName
											ELSE CONCAT(p.FirstName, ' ', p.LastName)
										END
									END, IdAccount, IdPriority, pr.[Name], oh.IdState, s.[Name],
									StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
									oh.EndDate, oh.RegisterUser, oh.RegisterDate
						END
					ELSE
						BEGIN
							SELECT	oh.Id[IdOpaHeader], UserName, IdCustomer, 
									CASE WHEN p.IsEnterprise = 1
										THEN p.EnterpriseName
										ELSE CASE WHEN p.LastName IS NULL
											THEN p.FirstName
											ELSE CONCAT(p.FirstName, ' ', p.LastName)
										END
									END[CustomerName], IdAccount, IdPriority, pr.[Name][PriorityName], oh.IdState, s.[Name][StateName],
									StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
									oh.EndDate, oh.RegisterUser, oh.RegisterDate, 
									CONCAT(dbo.fncg_Transmited(oh.Id), '/', COUNT(od.Id))[TransmitedLabel], dbo.fncg_Transmited(oh.Id)[Transmited]
							  FROM	OpaHeader oh INNER JOIN OpaDetail od ON oh.Id = od.IdOpaHeader
												 INNER JOIN [Customer] c ON oh.IdCustomer = c.IdPerson
												 INNER JOIN [Person] p ON c.IdPerson = p.Id
												 INNER JOIN [Priority] pr ON oh.IdPriority = pr.Id
												 INNER JOIN [State] s ON oh.IdState = s.Id
							 WHERE	oh.IdState = @IdState
							   AND	oh.UserName = @UserName
							   AND	oh.IdCustomer = @IdCustomer
							 GROUP BY oh.Id, UserName, IdCustomer, 
									CASE WHEN p.IsEnterprise = 1
										THEN p.EnterpriseName
										ELSE CASE WHEN p.LastName IS NULL
											THEN p.FirstName
											ELSE CONCAT(p.FirstName, ' ', p.LastName)
										END
									END, IdAccount, IdPriority, pr.[Name], oh.IdState, s.[Name],
									StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
									oh.EndDate, oh.RegisterUser, oh.RegisterDate
						END
				END
		END
	ELSE
	BEGIN
		IF(ISNULL(@IdState, 0) = 0)
			BEGIN
				SELECT	oh.Id[IdOpaHeader], UserName, IdCustomer, 
							CASE WHEN p.IsEnterprise = 1
								THEN p.EnterpriseName
								ELSE CASE WHEN p.LastName IS NULL
									THEN p.FirstName
									ELSE CONCAT(p.FirstName, ' ', p.LastName)
								END
							END[CustomerName], IdAccount, IdPriority, pr.[Name][PriorityName], oh.IdState, s.[Name][StateName],
							StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
							oh.EndDate, oh.RegisterUser, oh.RegisterDate, 
							CONCAT(dbo.fncg_Transmited(oh.Id), '/', COUNT(od.Id))[TransmitedLabel], dbo.fncg_Transmited(oh.Id)[Transmited]
					  FROM	OpaHeader oh INNER JOIN OpaDetail od ON oh.Id = od.IdOpaHeader
										 INNER JOIN [Customer] c ON oh.IdCustomer = c.IdPerson
										 INNER JOIN [Person] p ON c.IdPerson = p.Id
										 INNER JOIN [Priority] pr ON oh.IdPriority = pr.Id
										 INNER JOIN [State] s ON oh.IdState = s.Id
					 WHERE	OH.Id = @IdOpaHeader
					   AND	oh.UserName = @UserName
					   AND	oh.IdCustomer = @IdCustomer
					   AND	oh.IdState NOT IN (	SELECT	Id
												  FROM	[State]
												 WHERE	Name IN ('Ingresado',
																	'Grabado',
																	'Revisado',
																	'Transmitido',
																	'Finalizado'))
					 GROUP BY oh.Id, UserName, IdCustomer, 
							CASE WHEN p.IsEnterprise = 1
								THEN p.EnterpriseName
								ELSE CASE WHEN p.LastName IS NULL
									THEN p.FirstName
									ELSE CONCAT(p.FirstName, ' ', p.LastName)
								END
							END, IdAccount, IdPriority, pr.[Name], oh.IdState, s.[Name],
							StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
							oh.EndDate, oh.RegisterUser, oh.RegisterDate
			END
		ELSE
			BEGIN
				IF(@IdStateTransmited = @IdState)
					BEGIN
						SELECT	oh.Id[IdOpaHeader], UserName, IdCustomer, 
								CASE WHEN p.IsEnterprise = 1
									THEN p.EnterpriseName
									ELSE CASE WHEN p.LastName IS NULL
										THEN p.FirstName
										ELSE CONCAT(p.FirstName, ' ', p.LastName)
									END
								END[CustomerName], IdAccount, IdPriority, pr.[Name][PriorityName], oh.IdState, s.[Name][StateName],
								StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
								oh.EndDate, oh.RegisterUser, oh.RegisterDate, 
								CONCAT(dbo.fncg_Transmited(oh.Id), '/', COUNT(od.Id))[TransmitedLabel], dbo.fncg_Transmited(oh.Id)[Transmited]
						  FROM	OpaHeader oh INNER JOIN OpaDetailHist od ON oh.Id = od.IdOpaHeader
											 INNER JOIN [Customer] c ON oh.IdCustomer = c.IdPerson
											 INNER JOIN [Person] p ON c.IdPerson = p.Id
											 INNER JOIN [Priority] pr ON oh.IdPriority = pr.Id
											 INNER JOIN [State] s ON oh.IdState = s.Id
						 WHERE	oh.Id = @IdOpaHeader
						   AND	oh.IdState = @IdStateTransmited
						   AND	oh.UserName = @UserName
						   AND	oh.IdCustomer = @IdCustomer
						 GROUP BY oh.Id, UserName, IdCustomer, 
								CASE WHEN p.IsEnterprise = 1
									THEN p.EnterpriseName
									ELSE CASE WHEN p.LastName IS NULL
										THEN p.FirstName
										ELSE CONCAT(p.FirstName, ' ', p.LastName)
									END
								END, IdAccount, IdPriority, pr.[Name], oh.IdState, s.[Name],
								StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
								oh.EndDate, oh.RegisterUser, oh.RegisterDate
					END
				ELSE
					BEGIN
						SELECT	oh.Id[IdOpaHeader], UserName, IdCustomer, 
								CASE WHEN p.IsEnterprise = 1
									THEN p.EnterpriseName
									ELSE CASE WHEN p.LastName IS NULL
										THEN p.FirstName
										ELSE CONCAT(p.FirstName, ' ', p.LastName)
									END
								END[CustomerName], IdAccount, IdPriority, pr.[Name][PriorityName], oh.IdState, s.[Name][StateName],
								StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
								oh.EndDate, oh.RegisterUser, oh.RegisterDate, 
								CONCAT(dbo.fncg_Transmited(oh.Id), '/', COUNT(od.Id))[TransmitedLabel], dbo.fncg_Transmited(oh.Id)[Transmited]
						  FROM	OpaHeader oh INNER JOIN OpaDetail od ON oh.Id = od.IdOpaHeader
											 INNER JOIN [Customer] c ON oh.IdCustomer = c.IdPerson
											 INNER JOIN [Person] p ON c.IdPerson = p.Id
											 INNER JOIN [Priority] pr ON oh.IdPriority = pr.Id
											 INNER JOIN [State] s ON oh.IdState = s.Id
						 WHERE	oh.Id = @IdOpaHeader
						   AND	oh.IdState = @IdState
						   AND	oh.UserName = @UserName
						   AND	oh.IdCustomer = @IdCustomer
						 GROUP BY oh.Id, UserName, IdCustomer, 
								CASE WHEN p.IsEnterprise = 1
									THEN p.EnterpriseName
									ELSE CASE WHEN p.LastName IS NULL
										THEN p.FirstName
										ELSE CONCAT(p.FirstName, ' ', p.LastName)
									END
								END, IdAccount, IdPriority, pr.[Name], oh.IdState, s.[Name],
								StartDateHeader, EndDateHeader, EnterpriseCode, oh.Nit, oh.ImporterCode, oh.ExporterCode, oh.StartDate, 
								oh.EndDate, oh.RegisterUser, oh.RegisterDate
					END
			END
	END