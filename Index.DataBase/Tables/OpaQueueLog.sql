CREATE TABLE [dbo].[OpaQueueLog]
(
	[IdOpaHeader] INT NOT NULL,
	[IdPriority] INT NOT NULL,
	[IdState] INT NOT NULL,
	[DEscription] VARCHAR(500) NULL,
	[StartDate] DATETIME NULL,
	[EndDate] DATETIME NULL,
	PRIMARY KEY([IdOpaHeader]),
	FOREIGN KEY([IdOpaHeader]) REFERENCES [OpaHeader]([Id]),
	FOREIGN KEY([IdState]) REFERENCES [State]([Id]),
	FOREIGN KEY([IdPriority]) REFERENCES [Priority]([Id])
)
