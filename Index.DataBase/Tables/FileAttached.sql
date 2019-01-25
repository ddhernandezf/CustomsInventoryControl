CREATE TABLE [dbo].[FileAttached]
(
	[Id] INT IDENTITY NOT NULL,
	[IdFileHeader] INT NOT NULL,
	[IdSupplier] INT NULL,
	[Description] VARCHAR(300) NULL,
	[AttachedNumber] VARCHAR(1000) NULL,
	[AttachedDate] DATETIME NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	FOREIGN KEY([IdFileHeader]) REFERENCES [FileHeader]([Id]),
	FOREIGN KEY([IdSupplier]) REFERENCES [Supplier]([IdPerson])
)
