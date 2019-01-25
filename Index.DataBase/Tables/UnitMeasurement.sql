CREATE TABLE [dbo].[UnitMeasurement]
(
	[Id] INT NOT NULL IDENTITY,
	[Name] VARCHAR(150) NOT NULL, 
	[Description] VARCHAR(1000) NULL,
	[Symbol] VARCHAR(4) NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([Name])
)
