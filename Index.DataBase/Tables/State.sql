CREATE TABLE [dbo].[State]
(
	[Id] INT IDENTITY NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([Name])
)
