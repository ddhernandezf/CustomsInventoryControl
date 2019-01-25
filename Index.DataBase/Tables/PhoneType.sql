CREATE TABLE [dbo].[PhoneType]
(
	[Id] INT NOT NULL IDENTITY,
	[Description] VARCHAR(50) NOT NULL,
	PRIMARY KEY (Id),
	CONSTRAINT uq_PhoneType UNIQUE([Description])
)
