CREATE TABLE [dbo].[FileItemDischarge]
(
	[Id] INT IDENTITY NOT NULL,
	[IdFileDetailSubstract] INT NOT NULL,
	[IdFileDetailStock] INT NOT NULL,
	[IdState] INT NOT NULL,
	[Quantity] DECIMAL(18,6) NOT NULL,
	[Decrease] DECIMAL(18,6) NOT NULL,
	[CIFcost] DECIMAL(18,6) NOT NULL,
	[FOcost] DECIMAL(18,6)  NULL,
	[CustomDuties] DECIMAL(18,6) NULL,
	[Iva] DECIMAL(18,6) NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	FOREIGN KEY([IdState]) REFERENCES [State]([Id]),
	FOREIGN KEY([IdFileDetailSubstract]) REFERENCES [FileDetail]([Id]),
	FOREIGN KEY([IdFileDetailStock]) REFERENCES [FileDetail]([Id])
)
go
create index idx_FileItemDischarge_rd ON FileItemDischarge (RegisterDate)
go
create index idx_FileItemDischarge_st ON FileItemDischarge (IdState)
go