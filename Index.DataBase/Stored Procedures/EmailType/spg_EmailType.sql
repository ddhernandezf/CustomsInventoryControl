CREATE PROCEDURE [dbo].[spg_EmailType]
	@Id	INT
AS
	IF(ISNULL(@Id, 0) = 0)
		BEGIN
			SELECT	Id, [Description]
			  FROM	EmailType
		END
	ELSE
		BEGIN
			SELECT	Id, [Description]
			  FROM	EmailType
			 WHERE	Id = @Id
		END
