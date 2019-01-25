CREATE TABLE [dbo].[Currency]
(
	[Id] INT NOT NULL IDENTITY,
	[IdCountry] INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	[Description] VARCHAR(1000) NULL,
	[Symbol] VARCHAR(4) NOT NULL,
	[ExchangeRate] DECIMAL(10,2) NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([IdCountry],[Name]),
	FOREIGN KEY ([IdCountry]) REFERENCES [Country]([Id])
)
