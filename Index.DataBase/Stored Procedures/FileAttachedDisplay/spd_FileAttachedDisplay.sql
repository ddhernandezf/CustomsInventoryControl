CREATE PROCEDURE [dbo].[spd_FileAttachedDisplay]
	@Id	INT
AS
	DELETE FROM [FileAttachedDisplay] WHERE Id = @Id;