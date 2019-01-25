CREATE TABLE [dbo].[CustomerAccount]
(
	[IdCustomer] INT NOT NULL,
	[IdAccount] INT NOT NULL,
	[ResolutionRate]  NVARCHAR(100) NULL,
	[RegimeRate]  NVARCHAR(100) NULL,
	[ResolutionStartDate] DATE NULL,
	[ResolutionEndDate] DATE NULL,
	[FiscalPeriodStartDate]  DATE NULL,
	[FiscalPeriodEndDate]  DATE NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([IdCustomer],[IdAccount]),
	FOREIGN KEY([IdCustomer]) REFERENCES [Person]([Id]),
	FOREIGN KEY([IdAccount]) REFERENCES [Account]([Id]),
)
