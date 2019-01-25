CREATE TABLE [dbo].[Premission]
(
	[Id] INT NOT NULL IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	[Description] VARCHAR(1000) NOT NULL,
	[Area] VARCHAR(1000) NULL,
	[Controller] VARCHAR(100) NULL,
	[Action] VARCHAR(100) NULL,
	[Parameters] VARCHAR(100) NULL,
	[IdParent] INT NOT NULL,
	[Image] VARCHAR(3000) NULL,
	[ShowMenu] BIT NOT NULL,
	[Order] INT NOT NULL,
	[HasCredentials] BIT NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE ([Name])
)
