CREATE TABLE [dbo].[OpaDetailHist]
(
	[Id] INT NOT NULL IDENTITY,
	[IdOpaHeader] INT NOT NULL,
	[IdState] INT NOT NULL,
	[IdFileItemDischarge] INT NOT NULL,
	[IdFileHeaderSubstract] INT NOT NULL,
	[IdFileDetailSubstract] INT NOT NULL,
	[IdDocumentSubstract] VARCHAR(100) NOT NULL,
	[TransactionLineSubstract] INT NOT NULL,
	[QuantitySubstract] DECIMAL(18,6) NOT NULL,
	[CifSubstract] DECIMAL(18,6) NOT NULL,
	[FobSubstract] DECIMAL(18,6) NOT NULL,
	[CustomDutiesSubstract] DECIMAL(18,6) NOT NULL,
	[IvaSubstract] DECIMAL(18,6) NOT NULL,
	[IdFileHeaderStock] INT NOT NULL,
	[IdFileDetailStock] INT NOT NULL,
	[IdDocumentStock] VARCHAR(100) NOT NULL,
	[TransactionLineStock] INT NOT NULL,
	[StartDate] DATETIME NULL,
	[EndDate] DATETIME NULL,
	PRIMARY KEY([Id]),
	FOREIGN KEY([IdOpaHeader]) REFERENCES [OpaHeader]([Id]),
	FOREIGN KEY([IdState]) REFERENCES [State]([Id]),
	FOREIGN KEY([IdFileItemDischarge]) REFERENCES [FileItemDischarge]([Id]),
	FOREIGN KEY([IdFileHeaderSubstract]) REFERENCES [FileHeader]([Id]),
	FOREIGN KEY([IdFileDetailSubstract]) REFERENCES [FileDetail]([Id]),
	FOREIGN KEY([IdFileHeaderStock]) REFERENCES [FileHeader]([Id]),
	FOREIGN KEY([IdFileDetailStock]) REFERENCES [FileDetail]([Id])
)
GO
create index idx_OpaDetailHist_odh ON OpaDetailHist (IdFileItemDischarge)
GO