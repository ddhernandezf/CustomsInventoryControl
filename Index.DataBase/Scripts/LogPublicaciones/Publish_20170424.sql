DECLARE	@IdReportes INT;
SET @IdReportes = (SELECT Id FROM [Premission] WHERE Name = 'Reportes');

INSERT INTO [Premission] VALUES('Declaraciones','',null,null,null,null,@IdReportes,'Reportes.png',1,0, 0);
INSERT INTO [Premission] VALUES('Detalles','',null,null,null,null,@IdReportes,'Reportes.png',1,1, 0);
INSERT INTO [Premission] VALUES('Listados','',null,null,null,null,@IdReportes,'Reportes.png',1,2, 0);

DECLARE @RptDeclaraciones	INT,
		@RptDetalles		INT,
		@RptListados		INT;
SET @RptDeclaraciones = (SELECT Id FROM [Premission] WHERE Name = 'Declaraciones');
SET @RptDetalles = (SELECT Id FROM [Premission] WHERE Name = 'Detalles');
SET @RptListados = (SELECT Id FROM [Premission] WHERE Name = 'Listados');

UPDATE	Premission
   SET	IdParent = @RptDeclaraciones
 WHERE	[Name] IN ('Declaración Jurada','Declaración Jurada Gerencial','Declaración Jurada IVA separado')

UPDATE	Premission
   SET	IdParent = @RptDetalles
 WHERE	[Name] IN ('Detalle de descargo','Detalle exportacion')

UPDATE	Premission
   SET	IdParent = @RptListados
 WHERE	[Name] IN ('Lista Importacion','Lista Exportacion')
