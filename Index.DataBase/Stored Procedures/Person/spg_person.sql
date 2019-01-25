CREATE PROCEDURE [dbo].[spg_person]
	@Id INT
AS
	IF(ISNULL(@Id,0) = 0)
		BEGIN
			SELECT	Id,FirstName,LastName,Nit
			  FROM	[Person]
			 WHERE	IsEnterprise = 0
		END
	ELSE
		BEGIN
			SELECT	Id,FirstName,LastName,Nit
			  FROM	[Person]
			 WHERE	Id = @Id
			   AND	IsEnterprise = 0
		END

