CREATE PROCEDURE [dbo].[spd_Enterprise]
	@Id INT
AS
	DELETE FROM [Person] WHERE Id = @Id AND IsEnterprise = 1;
