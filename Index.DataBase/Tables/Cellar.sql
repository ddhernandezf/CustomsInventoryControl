CREATE TABLE [dbo].[Cellar]
(
	[Id] INT NOT NULL IDENTITY,
	[Name] VARCHAR(250) NOT NULL,
	[Address] VARCHAR(300) NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE ([Name])
)
