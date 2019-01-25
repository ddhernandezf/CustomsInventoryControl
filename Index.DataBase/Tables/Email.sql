CREATE TABLE [dbo].[Email]
(
	[Id] INT NOT NULL IDENTITY,
	[IdPerson] INT NOT NULL,
	[IdEmailType] INT NOT NULL,
	[Email] VARCHAR(300),
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([IdPerson],[Email]),
	FOREIGN KEY([IdPerson]) REFERENCES [Person]([Id]),
	FOREIGN KEY([IdEmailType]) REFERENCES [EmailType]([Id])
)
