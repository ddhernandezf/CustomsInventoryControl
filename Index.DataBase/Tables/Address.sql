CREATE TABLE [dbo].[Address]
(
	[Id] INT IDENTITY NOT NULL,
	[IdAddressType] INT NOT NULL,
	[IdPerson] INT NOT NULL,
	[Address] VARCHAR(250) NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([IdPerson],[Address]),
	FOREIGN KEY([IdPerson]) REFERENCES [Person]([Id]),
	FOREIGN KEY([IdAddressType]) REFERENCES [AddressType]([Id])
)
