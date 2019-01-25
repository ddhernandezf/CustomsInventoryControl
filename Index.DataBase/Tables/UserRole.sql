CREATE TABLE [dbo].[UserRole]
(
	[UserName] VARCHAR(60) NOT NULL,
	[IdRole] INT NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY ([UserName],[IdRole]),
	FOREIGN KEY([UserName]) REFERENCES [User]([UserName]),
	FOREIGN KEY([IdRole]) REFERENCES [Role]([Id]),
)
