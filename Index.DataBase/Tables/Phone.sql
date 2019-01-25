CREATE TABLE [dbo].[Phone]
(
	[Id] INT NOT NULL IDENTITY,
	[IdPerson] INT NOT NULL,
	[IdPhoneType] INT NOT NULL,
	[Number] VARCHAR(15),
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([IdPerson],[Number]),
	FOREIGN KEY([IdPerson]) REFERENCES [Person]([Id]),
	FOREIGN KEY([IdPhoneType]) REFERENCES [PhoneType]([Id])
)
