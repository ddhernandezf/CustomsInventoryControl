CREATE PROCEDURE [dbo].[spg_Queue]
AS
	SELECT	oq.IdOpaHeader, oq.IdPriority, p.[Name][PriorityName], p.Number[PriorityNumber], oq.StartDate, oq.EndDate,
			oh.UserName, oh.RegisterDate
	  FROM	[OpaQueue] oq INNER JOIN [Priority] p ON oq.IdPriority = p.Id
						  INNER JOIN [State] s ON oq.IdState = s.Id
						  INNER JOIN [OpaHeader] oh ON oq.IdOpaHeader = oh.Id
	 WHERE	oq.IdState = (SELECT Id FROM [State] WHERE [Name] = 'Cola')
	 ORDER BY p.Number ASC, oh.RegisterDate ASC