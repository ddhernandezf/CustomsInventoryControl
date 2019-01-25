CREATE TABLE [dbo].[FileDetail]
(
	[Id] INT IDENTITY NOT NULL,
	[IdFileHeader] INT NOT NULL,
	[IdState] INT NOT NULL,
	[TransactionLine] INT NULL,
	[IdItem] INT NOT NULL,
	[ItemQuantity] DECIMAL(18, 6) NULL,
	[CIFCotQuetzal] DECIMAL(18,6) NULL,
	[FOCostQuetzal] DECIMAL(18,6) NULL,
	[CIFCotDollar] DECIMAL(18,6) NULL,
	[FOCostDollar] DECIMAL(18,6) NULL,
	[CustomDuties] DECIMAL(18,6) NULL,
	[Iva] DECIMAL(18,6) NULL,
	[TaxableBase] DECIMAL(18,6) NULL,
	[TaxRate] DECIMAL(18,6) NULL,
	[NetWeight] DECIMAL(18,6) NULL,
	[GrossWeight] DECIMAL(18,6) NULL,
	[RegisterDate] DATETIME NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	FOREIGN KEY([IdFileHeader]) REFERENCES [FileHeader]([Id]),
	FOREIGN KEY([IdItem]) REFERENCES [Item]([Id]),
	FOREIGN KEY([IdState]) REFERENCES [State]([Id])
)
go
create index idx_FileDetail_fh ON FileDetail (IdFileHeader)
go