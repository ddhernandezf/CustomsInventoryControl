CREATE PROCEDURE [dbo].[spg_Menu]
AS
	SELECT	Id, Name, [Description], Area, Controller, [Action], [Parameters],
			IdParent, [Image], ShowMenu, [Order], HasCredentials
	  FROM	[Premission]
	 WHERE ShowMenu = 1
	 ORDER BY IdParent, [Order]