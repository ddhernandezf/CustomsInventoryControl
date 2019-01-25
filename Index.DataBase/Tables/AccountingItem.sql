CREATE TABLE [dbo].[AccountingItem]
(
	[Id] INT NOT NULL IDENTITY,
	[AccountingItem] VARCHAR(45) NOT NULL,
	[Description] VARCHAR(1000) NULL,
	[Parent] VARCHAR(45) NULL,
	[Level] INT NOT NULL,
	[CustomDuties] DECIMAL(18,6) NULL,
	[Usable] BIT NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([AccountingItem])
)
