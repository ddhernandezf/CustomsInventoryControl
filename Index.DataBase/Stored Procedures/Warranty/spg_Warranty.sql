CREATE PROCEDURE [dbo].[spg_Warranty]
	@Id	INT
AS
	IF(ISNULL(@Id, 0) = 0)
	BEGIN
		SELECT	Id, Name, [Description]
		  FROM	[Warranty];
	END
	ELSE
	BEGIN
		SELECT	Id, Name, [Description]
		  FROM	[Warranty]
		 WHERE	Id = @Id;
	END
