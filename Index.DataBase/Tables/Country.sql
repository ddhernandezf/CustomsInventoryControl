CREATE TABLE [dbo].[Country]
(
	[Id] INT NOT NULL IDENTITY,
	[Name] VARCHAR(200) NOT NULL,
	[IdParent]	INT NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE ([Name])
)
