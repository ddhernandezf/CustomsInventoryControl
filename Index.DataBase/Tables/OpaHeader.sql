CREATE TABLE [dbo].[OpaHeader]
(
	[Id] INT NOT NULL IDENTITY,
	[UserName] VARCHAR(60) NOT NULL,
	[IdCustomer] INT NOT NULL,
	[IdAccount] INT NOT NULL,
	[IdPriority] INT NOT NULL,
	[IdState] INT NOT NULL,
	[StartDateHeader] DATE NOT NULL,
	[EndDateHeader] DATE NOT NULL,
	[EnterpriseCode] VARCHAR(100) NULL,
	[Nit] VARCHAR(15) NULL,
	[ImporterCode] VARCHAR(100) NULL,
	[ExporterCode] VARCHAR(100) NULL,
	[StartDate] DATETIME NULL,
	[EndDate] DATETIME NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	PRIMARY KEY([Id]),
	FOREIGN KEY([UserName]) REFERENCES [User]([UserName]),
	FOREIGN KEY([IdCustomer]) REFERENCES [Customer]([IdPerson]),
	FOREIGN KEY([IdAccount]) REFERENCES [Account]([Id]),
	FOREIGN KEY([IdPriority]) REFERENCES [Priority]([Id]),
	FOREIGN KEY([IdState]) REFERENCES [State]([Id])

)
