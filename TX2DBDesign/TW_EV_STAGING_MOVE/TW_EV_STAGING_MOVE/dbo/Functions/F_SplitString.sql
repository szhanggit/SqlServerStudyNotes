
CREATE FUNCTION [dbo].[F_SplitString]
(
	@SourceString VARCHAR(MAX),
	@Seperator VARCHAR(25) = ','
)
RETURNS @ResultTable TABLE
(
	[Position] INT IDENTITY(1,1),
	[Value] VARCHAR(MAX)
)
AS
BEGIN
    DECLARE @w_xml xml;

    SET @w_xml = N'<root><i>' + replace(@SourceString, @Seperator,'</i><i>') + '</i></root>';

    INSERT INTO @ResultTable ([Value])
    SELECT [i].value('.', 'VARCHAR(MAX)') AS Value
    FROM @w_xml.nodes('//root/i') AS [Items]([i]);
    RETURN;
    END;
