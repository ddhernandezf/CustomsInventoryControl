CREATE PROCEDURE [dbo].[spd_CustomerDischarge]
	@Id	INT
AS
	DELETE FROM [CustomerDischarge] WHERE Id = @Id;
