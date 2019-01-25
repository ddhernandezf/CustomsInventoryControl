CREATE TABLE [dbo].[Supplier]
(
	[IdPerson] INT NOT NULL,
	[Observations] VARCHAR(1000) NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	[IsDestinySupplier] BIT NOT NULL,
	PRIMARY KEY([IdPerson]),
	FOREIGN KEY([IdPerson]) REFERENCES [Person]([Id])
)
