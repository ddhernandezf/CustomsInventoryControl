CREATE TABLE [dbo].[Table]
(
	[Id] INT IDENTITY NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([Name])
)
