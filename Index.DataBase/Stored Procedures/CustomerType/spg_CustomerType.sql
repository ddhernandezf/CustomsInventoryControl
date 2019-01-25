CREATE PROCEDURE [dbo].[spg_CustomerType]
	@Id	INT
AS
	IF(ISNULL(@Id, 0) = 0)
		BEGIN
			SELECT	Id, [Description]
			  FROM	CustomerType
		END
	ELSE
		BEGIN
			SELECT	Id, [Description]
			  FROM	CustomerType
			 WHERE	Id = @Id
		END
