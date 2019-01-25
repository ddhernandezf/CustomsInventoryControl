CREATE FUNCTION dbo.fn_mgr_RemoveChars(@Input varchar(1000))
RETURNS VARCHAR(1000)
BEGIN
  DECLARE @pos INT
  SET @Pos = PATINDEX('%[^0-9]%',@Input)

  WHILE @Pos > 0
   BEGIN
    SET @Input = STUFF(@Input,@pos,1,'')
    SET @Pos = PATINDEX('%[^0-9]%',@Input)
   END

  RETURN @Input
END
GO
