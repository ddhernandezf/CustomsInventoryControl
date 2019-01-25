CREATE PROCEDURE [dbo].[spg_Account]
	@Id	INT
AS
	IF(ISNULL(@Id,0) = 0)
		BEGIN
			SELECT	Id,Name,Description
			  FROM	[Account]
		END
	ELSE
		BEGIN
			SELECT	Id,Name,Description
			  FROM	[Account]
			 WHERE	Id = @Id
		END
