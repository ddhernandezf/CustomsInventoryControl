CREATE PROCEDURE [dbo].[spg_AccountingItemTree]
	@IdResolution	INT
AS
	DECLARE @TempAccountingItem TABLE (
		[Id] INT NOT NULL,
		[AccountingItem] VARCHAR(45) NOT NULL,
		[Description] VARCHAR(1000) NULL,
		[Parent] VARCHAR(45) NULL,
		[Level] INT NOT NULL,
		[CustomDuties] DECIMAL(18,6) NULL,
		[Usable] BIT NOT NULL,
		[Assigned] BIT NOT NULL
	)
	
	INSERT INTO @TempAccountingItem(Id, AccountingItem, [Description], Parent, [Level], CustomDuties, Usable, Assigned)
	SELECT	ai.Id, ai.AccountingItem, ai.[Description], ai.Parent, ai.[Level], ai.CustomDuties, ai.Usable, 1
	  FROM	AccountingItem ai
	 WHERE	ai.Usable = 0

	INSERT INTO @TempAccountingItem(Id, AccountingItem, [Description], Parent, [Level], CustomDuties, Usable, Assigned)
	SELECT	ai.Id, ai.AccountingItem, ai.[Description], ai.Parent, ai.[Level], ai.CustomDuties, ai.Usable, 1
	  FROM	[ResolutionAccountingItem] rai INNER JOIN [AccountingItem] ai ON ai.Id = rai.IdAccountingItem
	 WHERE	rai.IdResolution = @IdResolution;

	INSERT INTO @TempAccountingItem(Id, AccountingItem, [Description], Parent, [Level], CustomDuties, Usable, Assigned)
	SELECT	ai.Id, ai.AccountingItem, ai.[Description], ai.Parent, ai.[Level], ai.CustomDuties, ai.Usable, 0
	  FROM	AccountingItem ai
	 WHERE	ai.Usable= 1
	   AND	ai.Id NOT IN (	SELECT	DISTINCT IdAccountingItem
						  FROM	[ResolutionAccountingItem]
						 WHERE	IdResolution = @IdResolution)

	SELECT	*
	  FROM	@TempAccountingItem