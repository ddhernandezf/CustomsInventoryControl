CREATE TABLE [dbo].[FileMasterDisplay]
(
	[Id] INT IDENTITY NOT NULL,
	[IdFileInfoConfig] INT NOT NULL,
	[IdField] INT NOT NULL,
	[Label] VARCHAR(150) NOT NULL,
	[IsUsed] BIT NOT NULL,
	[IsRequeried] BIT NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([Id]),
	UNIQUE([IdFileInfoConfig],[IdField]),
	FOREIGN KEY([IdFileInfoConfig]) REFERENCES [FileInfoConfig]([Id]),
	FOREIGN KEY([IdField]) REFERENCES [Fields]([Id]),
)
