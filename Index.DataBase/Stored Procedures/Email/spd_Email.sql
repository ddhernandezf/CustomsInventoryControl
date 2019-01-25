CREATE PROCEDURE [dbo].[spd_Email]
	@Id	INT
AS
	DELETE FROM [Email] WHERE Id = @Id
