UPDATE	[AccountingItem]
   SET	AccountingItem = REPLACE(AccountingItem, '.', '');

UPDATE	[AccountingItem]
   SET	Parent = REPLACE(Parent, '.', '')
 WHERE	Parent IS NOT NULL;