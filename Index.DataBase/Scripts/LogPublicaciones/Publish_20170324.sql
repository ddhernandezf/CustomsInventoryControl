INSERT INTO [Premission] VALUES('Lista Exportacion','',null,'Reportes','ListaExportacion',null,(SELECT Id FROM [Premission] WHERE Name = 'Reportes'),'Reportes.png',2,0, 1);
INSERT INTO [Premission] VALUES('Fichas Técnicas','',null,'Reportes','Formulas',null,(SELECT Id FROM [Premission] WHERE Name = 'Reportes'),'Reportes.png',2,0, 1);

INSERT INTO RolePremission VALUES ((SELECT Id FROM [Role] WHERE [Name] = 'Administrador'), (SELECT Id FROM Premission WHERE Name = 'Lista Exportacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES ((SELECT Id FROM [Role] WHERE [Name] = 'Administrador'), (SELECT Id FROM Premission WHERE Name = 'Fichas Técnicas'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES ((SELECT Id FROM [Role] WHERE [Name] = 'Super Administrador'), (SELECT Id FROM Premission WHERE Name = 'Lista Exportacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES ((SELECT Id FROM [Role] WHERE [Name] = 'Super Administrador'), (SELECT Id FROM Premission WHERE Name = 'Fichas Técnicas'), GETDATE(), 'SYS_USER')