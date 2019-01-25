CREATE TABLE [dbo].[FileInfo]
(
	[Id] INT IDENTITY NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	[Description] VARCHAR(1000) NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY ([Id]),
	UNIQUE([Name])
)
