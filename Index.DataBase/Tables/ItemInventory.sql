CREATE TABLE [dbo].[ItemInventory]
(
	[IdCustomer] INT NOT NULL,
	[IdAccount] INT NOT NULL,
	[IdFileHeader] INT NOT NULL,
	[IdFileDetail] INT NOT NULL,
	[IdItem] INT NOT NULL,
	[Quantity] DECIMAL(18,6)NOT NULL,
	[Stock] DECIMAL(18,6)NOT NULL,
	[CIFcost] DECIMAL(18,6) NOT NULL,
	[FOcost] DECIMAL(18,6) NULL,
	[CustomDuties] DECIMAL(18,6) NULL,
	[Iva] DECIMAL(18,6) NOT NULL,
	[Freeze] DECIMAL(18,6) NULL DEFAULT NULL,
	[TransactionDate] DATETIME NOT NULL,
	[IdState]	INT NOT NULL,
	PRIMARY KEY([IdCustomer], [IdAccount], [IdFileHeader], [IdFileDetail], [IdItem]),
	FOREIGN KEY([IdCustomer]) REFERENCES [Customer]([IdPerson]),
	FOREIGN KEY([IdAccount]) REFERENCES [Account]([Id]),
	FOREIGN KEY([IdFileHeader]) REFERENCES [FileHeader]([Id]),
	FOREIGN KEY([IdFileDetail]) REFERENCES [FileDetail]([Id]),
	FOREIGN KEY([IdItem]) REFERENCES [Item]([Id]),
	FOREIGN KEY([IdState]) REFERENCES [State]([Id])
)
