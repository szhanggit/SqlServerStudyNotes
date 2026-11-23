
CREATE PROCEDURE [dbo].[spResultFromSP]
	@inputTable Monitor_Execution_Input Readonly
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @outputTable TABLE([Name] varchar(100), Result bigint); 

	DECLARE @Id int;
	DECLARE @SP varchar(100);
	DECLARE @MonitorCursor as CURSOR;
	SET @MonitorCursor = CURSOR FOR select AlertId from @inputTable

	OPEN @MonitorCursor;
	FETCH NEXT FROM @MonitorCursor INTO @Id;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-------------

	select @SP = SP from @inputTable where AlertId = @Id
	insert into @outputTable([Name], Result) exec @SP;

	----------------
	FETCH NEXT FROM @MonitorCursor INTO @Id;
	END			

	select * from @outputTable

END
