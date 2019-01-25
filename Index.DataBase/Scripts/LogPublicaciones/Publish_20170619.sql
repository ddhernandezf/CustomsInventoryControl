---------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Premission VALUES ('Eliminar Transmitidos', '', null, null, null, null, 
								(SELECT Id FROM Premission WHERE Name = 'Transacciones'), 'DeleteTransmited.png', 0, 0, 0);

INSERT INTO RolePremission
SELECT	Id, (SELECT Id FROM Premission WHERE Name = 'Eliminar Transmitidos'),
		GETDATE(), 'SYS_USER'
  FROM	[Role]
 WHERE	Name <> 'Usuario';

---------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Premission VALUES ('Congelar Saldos', '', null, null, null, null, 
								(SELECT Id FROM Premission WHERE Name = 'Transacciones'), 'Congelar.png', 0, 0, 0);

INSERT INTO RolePremission
SELECT	Id, (SELECT Id FROM Premission WHERE Name = 'Congelar Saldos'),
		GETDATE(), 'SYS_USER'
  FROM	[Role]
 WHERE	Name <> 'Usuario';
---------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Premission VALUES('Materias-Productos', '', NULL, 'Reportes', 'ListaItem', NULL, 
						(SELECT Id FROM Premission WHERE Id = 33), 'Reportes.png', 1, 1, 1);

INSERT INTO RolePremission
SELECT	Id, (SELECT Id FROM Premission WHERE Name = 'Materias-Productos'), 
		GETDATE(), 'SYS_USER'
  FROM	[Role];
---------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Premission VALUES('Declaración Constancias', '', NULL, 'Reportes', 'DeclaracionConstancia', NULL, 
						(SELECT Id FROM Premission WHERE Name = 'Declaraciones'), 'Reportes.png', 1, 1, 1);

INSERT INTO RolePremission
SELECT	Id, (SELECT Id FROM Premission WHERE Name = 'Declaración Constancias'), GETDATE(), 'SYS_USER'
  FROM	[Role];
---------------------------------------------------------------------------------------------------------------------------------------------------
UPDATE Premission SET [Order] = 0 WHERE [Name] = 'Declaraciones';
UPDATE Premission SET [Order] = 1 WHERE [Name] = 'Detalles';
UPDATE Premission SET [Order] = 2 WHERE [Name] = 'Listados';
UPDATE Premission SET [Order] = 3 WHERE [Name] = 'Fichas Técnicas';
UPDATE Premission SET [Order] = 4 WHERE [Name] = 'Materias-Productos';
UPDATE Premission SET [Order] = 0 WHERE [Name] = 'Declaración Jurada';
UPDATE Premission SET [Order] = 1 WHERE [Name] = 'Declaración Jurada Gerencial';
UPDATE Premission SET [Order] = 2 WHERE [Name] = 'Declaración Jurada IVA separado';
UPDATE Premission SET [Order] = 3 WHERE [Name] = 'Declaración Constancias';
UPDATE Premission SET [Order] = 0 WHERE [Name] = 'Detalle de descargo';
UPDATE Premission SET [Order] = 1 WHERE [Name] = 'Detalle exportacion';
UPDATE Premission SET [Order] = 2 WHERE [Name] = 'Detalle de Constancias';
UPDATE Premission SET [Order] = 0 WHERE [Name] = 'Lista Importacion';
UPDATE Premission SET [Order] = 1 WHERE [Name] = 'Lista Exportacion';
---------------------------------------------------------------------------------------------------------------------------------------------------