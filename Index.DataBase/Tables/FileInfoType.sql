CREATE TABLE [dbo].[FileInfoType]
(
	[Id] INT IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Description] VARCHAR(150) NULL,
	PRIMARY KEY([Id]),
	UNIQUE([Name])
)
