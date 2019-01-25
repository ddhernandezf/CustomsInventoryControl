CREATE TABLE [dbo].[OpaResponseHist]
(
	[Id] INT NOT NULL IDENTITY,
	[IdOpaDetail] INT NOT NULL,
	[TransactionNumber] INT NOT NULL,
	[ErrorType] VARCHAR(1) NULL,
	[ErrorMessage] VARCHAR(350) NULL,
	[Cif] DECIMAL(18,6) NULL,
	[CustomDuties] DECIMAL(18,6) NULL,
	[Iva] DECIMAL(18,6) NULL,
	[NationalizationMulct] VARCHAR(200) NULL,
	[NationalizationMulctAmmount] DECIMAL(18,6) NULL,
	[ExtemporaneusMulct] VARCHAR(200) NULL,
	[ExtemporaneusMulctAmmount] DECIMAL(18,6) NULL,
	[ResponseDate] DATETIME NULL,
	FOREIGN KEY([IdOpaDetail]) REFERENCES [OpaDetailHist]([Id])
)
GO
create index idx_OpaResponseH_orh ON OpaResponseHist (IdOpaDetail)
GO