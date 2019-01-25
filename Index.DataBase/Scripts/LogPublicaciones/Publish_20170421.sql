DECLARE	@IdTransaccion	INT;
SET @IdTransaccion = (SELECT Id FROM [Premission] WHERE Name = 'Transacciones');
INSERT INTO [Premission] VALUES('Ajustes','',null,null,null,null,@IdTransaccion,'Adjustment.png',0,0, 0);