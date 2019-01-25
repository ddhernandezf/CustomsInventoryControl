CREATE TABLE [dbo].[EmailType]
(
	[Id] INT NOT NULL IDENTITY,
	[Description] VARCHAR(50) NOT NULL,
	PRIMARY KEY (Id),
	CONSTRAINT uq_EmailType UNIQUE([Description])
)
