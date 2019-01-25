INSERT INTO Premission VALUES ('Importaciones Congeladas', '', null,'Reportes', 'ListaCongelados', null,
								(SELECT Id FROM Premission WHERE Name = 'Listados'), 'Reportes.png', 1, 2, 1);

INSERT INTO RolePremission
SELECT	Id, (SELECT Id FROM Premission WHERE Name = 'Importaciones Congeladas'),
		GETDATE(), 'SYS_USER'
  FROM	[Role]
 WHERE	Name <> 'Usuario';
