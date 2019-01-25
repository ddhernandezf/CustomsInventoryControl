exec spi_User 'Carlos', 'Morales', null, 'cmorales', '21NDNrGnicMlydJANOIQxA(i)(i)', '21NDNrGnicMlydJANOIQxA(i)(i)', 1, 1, 0, 1, 'SYSUSER'
exec spi_User 'César', 'Chácon', null, 'cchacon', '21NDNrGnicMlydJANOIQxA(i)(i)', '21NDNrGnicMlydJANOIQxA(i)(i)', 1, 1, 0, 1, 'SYSUSER'
exec spi_User 'Alex', 'Menchú', null, 'amenchu', '21NDNrGnicMlydJANOIQxA(i)(i)', '21NDNrGnicMlydJANOIQxA(i)(i)', 1, 1, 0, 1, 'SYSUSER'
exec spi_User 'Jordi', 'Chávez', null, 'jchavez', '21NDNrGnicMlydJANOIQxA(i)(i)', '21NDNrGnicMlydJANOIQxA(i)(i)', 1, 1, 0, 1, 'SYSUSER'
exec spi_User 'Manolo', 'Palacios', null, 'mpalacios', '21NDNrGnicMlydJANOIQxA(i)(i)', '21NDNrGnicMlydJANOIQxA(i)(i)', 1, 1, 0, 1, 'SYSUSER'
exec spi_User 'Carlos Yovani', 'García', null, 'cgarcia', '21NDNrGnicMlydJANOIQxA(i)(i)', '21NDNrGnicMlydJANOIQxA(i)(i)', 1, 1, 0, 1, 'SYSUSER'
exec spi_User 'Erick', 'Sacúl', null, 'esacul', '21NDNrGnicMlydJANOIQxA(i)(i)', '21NDNrGnicMlydJANOIQxA(i)(i)', 1, 1, 0, 1, 'SYSUSER'
exec spi_User 'Luis', 'Fernando', null, 'lfernando', '21NDNrGnicMlydJANOIQxA(i)(i)', '21NDNrGnicMlydJANOIQxA(i)(i)', 1, 1, 0, 1, 'SYSUSER'
exec spi_User 'Douglas', 'Hernandez', null, 'ddhernandezf', 'j(m)y5vmR8Q5w(i)', 'j(m)y5vmR8Q5w(i)', 0, 1, 1, 1, 'SYS_USER'
exec spi_User 'Gabriel', 'Rangel', null, 'grangel', 'j(m)y5vmR8Q5w(i)', 'j(m)y5vmR8Q5w(i)', 0, 1, 1, 1, 'SYS_USER'

exec spi_role 'Super Administrador', 'Perfil para usuarios con acceso a todas las opciones del sistema', 'SYS_USER'
exec spi_role 'Administrador', 'Administración de información en general del sistema.', 'SYS_USER'
exec spi_role 'Usuario', 'Perfil de ingreso de información y generacón de reportes.', 'SYS_USER'

DECLARE @SuperAdmin	INT,
		@Admin		INT,
		@Usuario	INT
		
SELECT @SuperAdmin = Id FROM [Role] WHERE [Name] = 'Super Administrador'
SELECT @Admin = Id FROM [Role] WHERE [Name] = 'Administrador'
SELECT @Usuario = Id FROM [Role] WHERE [Name] = 'Usuario'

INSERT INTO [UserRole] VALUES ('cmorales', @Admin, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('cchacon', @Admin, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('amenchu', @Admin, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('jchavez', @Usuario, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('mpalacios', @Usuario, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('cgarcia', @Usuario, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('esacul', @Usuario, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('lfernando', @Usuario, GETDATE(), 'SYS_USER')

INSERT INTO [UserRole] VALUES ('ddhernandezf', @Admin, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('ddhernandezf', @Usuario, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('ddhernandezf', @SuperAdmin, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('grangel', @Admin, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('grangel', @Usuario, GETDATE(), 'SYS_USER')
INSERT INTO [UserRole] VALUES ('grangel', @SuperAdmin, GETDATE(), 'SYS_USER')

INSERT INTO RolePremission VALUES (@Usuario, (SELECT Id FROM Premission WHERE Name = 'Transacciones'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Usuario, (SELECT Id FROM Premission WHERE Name = 'Declaración Jurada'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Usuario, (SELECT Id FROM Premission WHERE Name = 'Declaración Jurada Gerencial'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Usuario, (SELECT Id FROM Premission WHERE Name = 'Declaración Jurada IVA separado'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Usuario, (SELECT Id FROM Premission WHERE Name = 'Detalle de descargo'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Usuario, (SELECT Id FROM Premission WHERE Name = 'Detalle exportacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Usuario, (SELECT Id FROM Premission WHERE Name = 'Lista Importacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Usuario, (SELECT Id FROM Premission WHERE Name = 'Lista Exportacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Usuario, (SELECT Id FROM Premission WHERE Name = 'Fichas Técnicas'), GETDATE(), 'SYS_USER')

INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Teléfonos'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Asignar cuenta'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Alta de usuario'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Proveedores'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Cliente Destino'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'País'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Moneda'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Bodega'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Aduana'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Cuentas'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Unidad medida'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Garantías'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Resoluciones'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Partidas'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Materia Prima'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Producto'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Formula'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Transacciones'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Declaración Jurada'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Declaración Jurada Gerencial'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Declaración Jurada IVA separado'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Detalle de descargo'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Detalle exportacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Lista Importacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Lista Exportacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Fichas Técnicas'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Transmitir Opa'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@Admin, (SELECT Id FROM Premission WHERE Name = 'Ajustes'), GETDATE(), 'SYS_USER')

INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Teléfonos'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Asignar cuenta'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Alta de usuario'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Proveedores'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Cliente Destino'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'País'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Moneda'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Bodega'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Aduana'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Cuentas'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Unidad medida'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Garantías'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Asignar Rol'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Asignar Clientes'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Asignar Permisos'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Resoluciones'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Partidas'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Documentos'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Campos'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Materia Prima'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Producto'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Formula'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Transacciones'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Declaración Jurada'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Declaración Jurada Gerencial'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Declaración Jurada IVA separado'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Detalle de descargo'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Detalle exportacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Lista Importacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Lista Exportacion'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Fichas Técnicas'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Transmitir Opa'), GETDATE(), 'SYS_USER')
INSERT INTO RolePremission VALUES (@SuperAdmin, (SELECT Id FROM Premission WHERE Name = 'Ajustes'), GETDATE(), 'SYS_USER')