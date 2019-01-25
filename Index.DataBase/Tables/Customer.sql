CREATE TABLE [dbo].[Customer]
(
	[IdPerson] INT NOT NULL, 
	[LegalRepresentative] VARCHAR(300) NULL,
	[PersonCode]  NVARCHAR(100) NULL,
	[ImporterCode]  NVARCHAR(100) NULL,
	[ExporterCode]  NVARCHAR(100) NULL,
	[Observations] VARCHAR(1000) NULL,
	[BondEndDate]  DATE NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([IdPerson]),
	FOREIGN KEY([IdPerson]) REFERENCES [Person]([Id])
)
