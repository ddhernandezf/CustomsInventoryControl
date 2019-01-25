CREATE PROCEDURE [dbo].[spd_Phone]
	@Id	INT
AS
	DELETE FROM [Phone] WHERE Id = @Id
