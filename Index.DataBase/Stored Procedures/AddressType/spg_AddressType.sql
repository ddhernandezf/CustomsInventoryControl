CREATE PROCEDURE [dbo].[spg_AddressType]
	@Id	INT
AS
	IF(ISNULL(@Id, 0) = 0)
		BEGIN
			SELECT	Id, [Description]
			  FROM	AddressType
		END
	ELSE
		BEGIN
			SELECT	Id, [Description]
			  FROM	AddressType
			 WHERE	Id = @Id
		END
