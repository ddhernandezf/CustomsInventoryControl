CREATE TABLE [dbo].[Role]
(
	[Id] INT NOT NULL IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	[Description] VARCHAR(1000) NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE ([Name])
)
