CREATE TABLE [dbo].[FileInfoConfig]
(
	[Id] INT IDENTITY NOT NULL,
	[IdFileInfo] INT NOT NULL,
	[IdFileType] INT NOT NULL,
	[IdAccount] INT NOT NULL,
	[UseAttached] BIT NOT NULL,
	[IsSubstract] BIT NOT NULL,
	[LoadRawMaterial] BIT NOT NULL,
	[Transmissible] BIT NOT NULL DEFAULT 0,
	[UseExpired]	BIT NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	[Active] BIT NOT NULL DEFAULT 1,
	PRIMARY KEY([Id]),
	UNIQUE([IdFileInfo],[IdFileType], [IdAccount]),
	FOREIGN KEY ([IdFileInfo]) REFERENCES [FileInfo]([Id]),
	FOREIGN KEY ([IdFileType]) REFERENCES [FileInfoType]([Id]),
	FOREIGN KEY ([IdAccount]) REFERENCES [Account]([Id])
)
