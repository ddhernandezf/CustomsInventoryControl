CREATE TABLE [dbo].[Fields]
(
	[Id] INT IDENTITY NOT NULL,
	[IdTable] INT NOT NULL,
	[Name] VARCHAR(150) NOT NULL,
	[DataBaseName] VARCHAR(150) NOT NULL,
	[HtmlObject] VARCHAR(150) NOT NULL,
	[IsRequired] BIT NOT NULL,
	PRIMARY KEY ([Id]),
	UNIQUE([IdTable],[DataBaseName]),
	FOREIGN KEY([IdTable]) REFERENCES [Table]([Id])
)
