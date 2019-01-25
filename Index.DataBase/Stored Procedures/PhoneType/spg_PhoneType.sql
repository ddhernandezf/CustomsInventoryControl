CREATE PROCEDURE [dbo].[spg_PhoneType]
	@Id	INT
AS
	IF(ISNULL(@Id, 0) = 0)
		BEGIN
			SELECT	Id, [Description]
			  FROM	PhoneType
		END
	ELSE
		BEGIN
			SELECT	Id, [Description]
			  FROM	PhoneType
			 WHERE	Id = @Id
		END
