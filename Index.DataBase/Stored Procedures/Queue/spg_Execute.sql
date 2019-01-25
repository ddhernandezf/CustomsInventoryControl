CREATE PROCEDURE [dbo].[spg_Execute]
AS
	DECLARE	@ProcState	INT
	SELECT @ProcState = Id FROM [State] WHERE [Name] = 'Procesando'

	SELECT	CASE WHEN COUNT(*) = 0
				THEN CONVERT(BIT, 0)
				ELSE CONVERT(BIT, 1)
			END[IsProccess]
	  FROM	[OpaQueue]
	 WHERE	IdState = @ProcState