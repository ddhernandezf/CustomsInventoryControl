CREATE TABLE [dbo].[RolePremission]
(
	[IdRole] INT NOT NULL,
	[IdPremission] INT NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY ([IdRole],[IdPremission]),
	FOREIGN KEY ([IdRole]) REFERENCES [Role]([Id]),
	FOREIGN KEY ([IdPremission]) REFERENCES [Premission]([Id]),
)
