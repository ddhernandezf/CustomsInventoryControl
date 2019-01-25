CREATE TABLE [dbo].[AddressType]
(
	[Id] INT IDENTITY NOT NULL,
	[Description] VARCHAR(50) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([Description])
)
