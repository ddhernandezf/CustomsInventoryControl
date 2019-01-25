CREATE PROCEDURE [dbo].[spd_Person]
	@Id INT
AS
	DELETE FROM [Person] WHERE Id = @Id AND IsEnterprise = 0;
