CREATE PROCEDURE [dbo].[spu_ItemChangeState]
	@IdOpaDetail	INT,
	@IdState		INT
AS
	DECLARE	@IdFileItemDischarge	INT

	SELECT	@IdFileItemDischarge = IdFileItemDischarge
	  FROM	[OpaDetail]
	 WHERE	Id = @IdOpaDetail
	
	UPDATE	[OpaDetail]
	   SET	IdState = @IdState
	 WHERE	Id= @IdOpaDetail

	UPDATE	[FileItemDischarge]
	   SET	IdState = @IdState
	 WHERE	Id = @IdFileItemDischarge