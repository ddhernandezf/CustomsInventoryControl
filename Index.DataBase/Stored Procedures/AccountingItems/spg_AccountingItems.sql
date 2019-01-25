CREATE PROCEDURE [dbo].[spg_AccountingItems]
	@IdAccountingItem	INT,
	@IdResolution		INT
AS
	IF(ISNULL(@IdResolution, 0) = 0)
		BEGIN
			IF(ISNULL(@IdAccountingItem, 0) = 0)
				BEGIN
					SELECT	ai.Id, 0[IdResolution], ''[ResolutionName],  ai.AccountingItem, ai.[Description], ai.Parent,
							pai.Id[IdParent], pai.[Description][ParentDescription], ai.[Level], ai.CustomDuties, ai.Usable,
							CONCAT(ai.AccountingItem, ' - ', ai.Description)[AccountingItemDisplay],
							CASE WHEN pai.AccountingItem IS NULL
								THEN	''
								ELSE	pai.AccountingItem
							END[ParentAccountingItem],
							CASE WHEN pai.AccountingItem IS NULL
								THEN	''
								ELSE	CONCAT(pai.AccountingItem, ' - ', pai.Description)
							END[ParentAccountingItemDisplay]
					  FROM	[AccountingItem] ai LEFT OUTER JOIN [AccountingItem] pai ON pai.AccountingItem = ai.Parent;
				END
			ELSE
				BEGIN
					SELECT	ai.Id, 0[IdResolution], ''[ResolutionName],  ai.AccountingItem, ai.[Description], ai.Parent,
							pai.Id[IdParent], pai.[Description][ParentDescription], ai.[Level], ai.CustomDuties, ai.Usable,
							CONCAT(ai.AccountingItem, ' - ', ai.Description)[AccountingItemDisplay],
							CASE WHEN pai.AccountingItem IS NULL
								THEN	''
								ELSE	pai.AccountingItem
							END[ParentAccountingItem],
							CASE WHEN pai.AccountingItem IS NULL
								THEN	''
								ELSE	CONCAT(pai.AccountingItem, ' - ', pai.Description)
							END[ParentAccountingItemDisplay]
					  FROM	[AccountingItem] ai LEFT OUTER JOIN [AccountingItem] pai ON pai.AccountingItem = ai.Parent
					 WHERE	ai.Id = @IdAccountingItem;
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdAccountingItem, 0) = 0)
				BEGIN
					SELECT	ai.Id, rai.IdResolution, r.[Name][ResolutionName], ai.AccountingItem, ai.[Description], ai.Parent, 
							pai.Id[IdParent], pai.[Description][ParentDescription], ai.[Level], ai.CustomDuties, ai.Usable,
							CONCAT(ai.AccountingItem, ' - ', ai.Description)[AccountingItemDisplay],
							CASE WHEN pai.AccountingItem IS NULL
								THEN	''
								ELSE	pai.AccountingItem
							END[ParentAccountingItem],
							CASE WHEN pai.AccountingItem IS NULL
								THEN	''
								ELSE	CONCAT(pai.AccountingItem, ' - ', pai.Description)
							END[ParentAccountingItemDisplay]
					  FROM	[ResolutionAccountingItem] rai INNER JOIN [AccountingItem] ai ON ai.Id = rai.IdAccountingItem
														   LEFT OUTER JOIN [AccountingItem] pai ON pai.AccountingItem = ai.Parent
														   INNER JOIN [Resolution] r ON r.Id = rai.IdResolution
					 WHERE	rai.IdResolution = @IdResolution;
				END
			ELSE
				BEGIN
					SELECT	ai.Id, rai.IdResolution, r.[Name][ResolutionName], ai.AccountingItem, ai.[Description], ai.Parent, 
							pai.Id[IdParent], pai.[Description][ParentDescription], ai.[Level], ai.CustomDuties, ai.Usable,
							CONCAT(ai.AccountingItem, ' - ', ai.Description)[AccountingItemDisplay],
							CASE WHEN pai.AccountingItem IS NULL
								THEN	''
								ELSE	pai.AccountingItem
							END[ParentAccountingItem],
							CASE WHEN pai.AccountingItem IS NULL
								THEN	''
								ELSE	CONCAT(pai.AccountingItem, ' - ', pai.Description)
							END[ParentAccountingItemDisplay]
					  FROM	[ResolutionAccountingItem] rai INNER JOIN [AccountingItem] ai ON ai.Id = rai.IdAccountingItem
														   LEFT OUTER JOIN [AccountingItem] pai ON pai.AccountingItem = ai.Parent
														   INNER JOIN [Resolution] r ON r.Id = rai.IdResolution
					 WHERE	rai.IdResolution = @IdResolution
					   AND	ai.Id = @IdAccountingItem;
				END
		END