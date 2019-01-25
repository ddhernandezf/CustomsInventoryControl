INSERT INTO Fields VALUES (1, 'Factura', 'Factura', 'TextBox', 0);

INSERT INTO Premission VALUES ('Detalle de Constancias', '', null, 'Reportes', 'DetalleConstancias', null, 
		(select Id from Premission where Name = 'Detalles'), 'Reportes.png', 1, 0, 1);

INSERT INTO RolePremission
SELECT	Id, (select Id from Premission where Name = 'Detalle de Constancias'),
		GETDATE(), 'SYS_USER'
  FROM	[Role];