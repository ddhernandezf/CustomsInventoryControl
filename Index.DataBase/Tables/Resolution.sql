CREATE TABLE [dbo].[Resolution]
(
	[Id] INT IDENTITY NOT NULL,
	[IdCustomer] INT NOT NULL,
	[IdAccount] INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	[Description] VARCHAR(1000) NULL,
	[RateDate] DATETIME NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([IdCustomer],[IdAccount],[Name]),
	FOREIGN KEY([IdCustomer]) REFERENCES [Customer]([IdPerson]),
	FOREIGN KEY([IdAccount]) REFERENCES [Account]([Id])
 )
