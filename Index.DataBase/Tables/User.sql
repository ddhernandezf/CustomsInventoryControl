CREATE TABLE [dbo].[User]
(
	[UserName] VARCHAR(60) NOT NULL,
	[IdPerson] INT NOT NULL,
	[SitePassword] VARCHAR(1000) NOT NULL,
	[MobilePassword] VARCHAR(1000) NOT NULL,
	[LastTransactionDate] DATETIME NOT NULL,
	[PasswordReset] BIT NOT NULL,
	[OAuthSite] BIT NOT NULL,
	[OAuthMobile] BIT NOT NULL,
	[Active] BIT NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([UserName]),
	UNIQUE([IdPerson]),
	FOREIGN KEY ([IdPerson]) REFERENCES [Person]([Id])
)
