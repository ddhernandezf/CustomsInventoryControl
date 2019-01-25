CREATE TABLE [dbo].[CustomerUser]
(
	[IdCustomer] INT NOT NULL,
	[UserName] VARCHAR(60) NOT NULL,
	[RegisterDate] DATETIME NOT NULL,
	[RegisterUser] VARCHAR(60) NOT NULL,
	PRIMARY KEY([IdCustomer],[UserName]),
	FOREIGN KEY([IdCustomer]) REFERENCES [Customer]([IdPerson]),
	FOREIGN KEY([UserName]) REFERENCES [User]([UserName])
)
