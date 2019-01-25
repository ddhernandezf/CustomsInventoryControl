CREATE TABLE [dbo].[Parameters]
(
	[IVA] DECIMAL(10,2) NOT NULL,
	[ExpirateDateMonts] INT NOT NULL,
	[DefaultCurrency] INT NULL,
	[DaysToExpire] INT NOT NULL,
	[OpaFrecuencySeconds] INT NOT NULL,
	[OpaDelaySeconds] INT NOT NULL,
	[OpaServiceUrl] VARCHAR(300) NOT NULL,
	[OpaServiceUser] VARCHAR(200) NOT NULL,
	[OpaServicePassword] VARCHAR(200) NOT NULL,
	[MailingUser] VARCHAR(200) NOT NULL,
	[MailingPassword] VARCHAR(200) NOT NULL,
	[MailingServer] VARCHAR(200) NOT NULL,
	[MailingPort] INT NOT NULL,
	[MailingUseSsl] BIT NOT NULL,
	[MailingDisplayName] VARCHAR(200) NOT NULL,
	[MailingIsHtml] BIT NOT NULL,
	[OpaEmailBody] VARCHAR(MAX) NOT NULL,
	[MailingCC] VARCHAR(MAX) NULL,
	[MailingCCO] VARCHAR(MAX) NULL,
	FOREIGN KEY([DefaultCurrency]) REFERENCES [Currency]([Id])
)
