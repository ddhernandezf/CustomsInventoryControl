CREATE PROCEDURE [dbo].[spd_FileDetailDisplay]
	@Id	INT
AS
	DELETE FROM [FileDetailDisplay] WHERE Id = @Id;