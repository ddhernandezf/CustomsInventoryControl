CREATE PROCEDURE [dbo].[spd_AccountingItemUnassing]
	@IdResolution		INT,
	@IdAccountingItem	INT
AS
	DELETE FROM [ResolutionAccountingItem] WHERE IdResolution = @IdResolution AND IdAccountingItem = @IdAccountingItem;