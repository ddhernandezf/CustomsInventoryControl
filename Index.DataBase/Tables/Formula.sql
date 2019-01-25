CREATE TABLE [dbo].[Formula]
(
	[Id] INT NOT NULL IDENTITY,
	[IdMainItem] INT NOT NULL,
	[IdDetailItem] INT NOT NULL,
	[Quantity] DECIMAL(18,6) NOT NULL,
	[Decrease] DECIMAL(18,6) NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	[Active] BIT NOT NULL DEFAULT 1,
	PRIMARY KEY([Id]),
	UNIQUE([IdMainItem],[IdDetailItem]),
	FOREIGN KEY([IdMainItem]) REFERENCES [Item]([Id]),
	FOREIGN KEY([IdDetailItem]) REFERENCES [Item]([Id])
)
