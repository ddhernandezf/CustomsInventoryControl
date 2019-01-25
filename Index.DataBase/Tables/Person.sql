CREATE TABLE [dbo].[Person]
(
	[Id] INT NOT NULL IDENTITY,
	[FirstName] VARCHAR(150) NULL,
	[LastName] VARCHAR(150) NULL,
	[Nit] VARCHAR(15) NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	[IsEnterprise] BIT NOT NULL,
	[EnterpriseName] VARCHAR(400) NULL,
	PRIMARY KEY([Id])
)
