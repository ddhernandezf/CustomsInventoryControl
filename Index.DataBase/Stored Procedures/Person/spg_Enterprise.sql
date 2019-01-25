
CREATE PROCEDURE [dbo].[spg_Enterprise]
	@Id INT
AS
	IF(ISNULL(@Id,0) = 0)
		BEGIN
			SELECT	Id,EnterpriseName,Nit
			  FROM	[Person]
			 WHERE	IsEnterprise = 1
		END
	ELSE
		BEGIN
			SELECT	Id,EnterpriseName,Nit
			  FROM	[Person]
			 WHERE	Id = @Id
			   AND	IsEnterprise = 1
		END

