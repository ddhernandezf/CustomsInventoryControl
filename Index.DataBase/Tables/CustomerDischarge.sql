CREATE TABLE [dbo].[CustomerDischarge]
(
	[Id] INT IDENTITY NOT NULL,
	[IdCustomer] INT NOT NULL,
	[FilePath] VARCHAR(2000) NOT NULL,
	[DocumentName] VARCHAR(300) NOT NULL,
	[DocumentDescription] VARCHAR(1000) NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	FOREIGN KEY([IdCustomer]) REFERENCES [Customer]([IdPerson])
)
