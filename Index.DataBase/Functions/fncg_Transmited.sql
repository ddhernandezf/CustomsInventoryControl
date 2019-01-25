CREATE FUNCTION [dbo].[fncg_Transmited](
	@IdOpaHeader INT
)
RETURNS INT
AS BEGIN
    DECLARE @Transmited		INT,
			@IdTransmited	INT

	SELECT @IdTransmited = Id FROM [State] WHERE [Name] = 'Transmitido'

	IF EXISTS (	SELECT	*
				  FROM	[OpaDetail]
				 WHERE	IdOpaHeader = @IdOpaHeader
				   AND	IdState = @IdTransmited)
		BEGIN
			SELECT	@Transmited = COUNT(*)
			  FROM	[OpaDetail]
			 WHERE	IdOpaHeader = @IdOpaHeader
			   AND	IdState = @IdTransmited
		END
	ELSE
		BEGIN
			SELECT	@Transmited = COUNT(*)
			  FROM	[OpaDetailHist]
			 WHERE	IdOpaHeader = @IdOpaHeader
			   AND	IdState = @IdTransmited
		END

    RETURN @Transmited
END