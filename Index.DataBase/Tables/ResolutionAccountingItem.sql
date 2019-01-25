CREATE TABLE [dbo].[ResolutionAccountingItem]
(
	[IdResolution] INT NOT NULL,
	[IdAccountingItem] INT NOT NULL,
	PRIMARY KEY([IdResolution], [IdAccountingItem]),
	FOREIGN KEY([IdResolution]) REFERENCES [Resolution]([Id]),
	FOREIGN KEY([IdAccountingItem]) REFERENCES [AccountingItem]([Id])
)
