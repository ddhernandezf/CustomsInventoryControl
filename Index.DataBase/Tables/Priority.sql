CREATE TABLE [dbo].[Priority]
(
	[Id] INT NOT NULL IDENTITY,
	[Name] VARCHAR(50),
	[Number] INT NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([Name])
)
