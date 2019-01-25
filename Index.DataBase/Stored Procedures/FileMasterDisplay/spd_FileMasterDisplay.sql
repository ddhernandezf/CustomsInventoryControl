CREATE PROCEDURE [dbo].[spd_FileMasterDisplay]
	@Id	INT
AS
	DELETE FROM [FileMasterDisplay] WHERE Id = @Id;