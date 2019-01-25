CREATE TABLE [dbo].[DestinyCustomer]
(
	[IdPerson] INT NOT NULL,
	PRIMARY KEY([IdPerson]),
	FOREIGN KEY ([IdPerson]) REFERENCES [Person]([Id])
)
