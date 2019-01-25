create function dbo.fn_mgr_split_string(
          @delimited NVARCHAR(MAX),
          @delimiter varchar(10)) 
RETURNS @Items TABLE (indice INT IDENTITY(1,1), valor NVARCHAR(MAX))
AS
BEGIN
    Declare @xml XML
    SET @xml = N'<t>' + REPLACE(@delimited,@delimiter,'</t><t>') + '</t>'

    INSERT INTO @Items(valor)
    SELECT  ltrim(rtrim(r.value('.','varchar(MAX)'))) as item
    FROM  @xml.nodes('/t') as records(r)
    RETURN
END