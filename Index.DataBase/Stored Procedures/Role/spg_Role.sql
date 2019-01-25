CREATE PROCEDURE [dbo].[spg_Role]
	@IdRole	INT
AS
	IF(ISNULL(@IdRole,0) = 0)
		BEGIN
			SELECT	Id, Name, [Description]
			  FROM	[Role];
		END
	ELSE
		BEGIN
			SELECT	Id, Name, [Description]
			  FROM	[Role]
			 WHERE	Id = @IdRole;
		END
