CREATE TABLE [dbo].[Customs]
(
	[Id] INT NOT NULL IDENTITY,
	[IdCountry] INT NOT NULL,
	[Name] VARCHAR(250) NOT NULL,
	[Address] VARCHAR(300) NOT NULL,
	[Code] VARCHAR(10) NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([IdCountry],[Name]),
	FOREIGN KEY([IdCountry]) REFERENCES [Country]([Id])
)
