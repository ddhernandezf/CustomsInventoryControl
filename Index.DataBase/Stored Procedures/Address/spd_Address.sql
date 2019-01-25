CREATE PROCEDURE [dbo].[spd_Address]
	@Id	INT
AS
	DELETE FROM [Address] WHERE Id = @Id
