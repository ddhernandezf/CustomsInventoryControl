CREATE PROCEDURE [dbo].[spi_AccountingItemAssing]
	@IdResolution		INT,
	@IdAccountingItem	INT
AS
	INSERT INTO [ResolutionAccountingItem](IdResolution, IdAccountingItem)
	VALUES (@IdResolution, @IdAccountingItem);