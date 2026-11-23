
CREATE PROCEDURE [dbo].[spGetRealTimeAlertInfoV2]
	@cqpcTable Alert_Input Readonly
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ResultTable TABLE(AlertId int, NeedAlertNum int, LastUpdateTime DateTime) 

	DECLARE @AId int;
	DECLARE @NeedAlertNum int;
	DECLARE @WindowSize int = 0;
	DECLARE @MonitorCursor as CURSOR;
	SET @MonitorCursor = CURSOR FOR select AlertId from @cqpcTable


	OPEN @MonitorCursor;
	FETCH NEXT FROM @MonitorCursor INTO @AId;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-------------
	select @WindowSize = WSize from @cqpcTable where AlertId = @AId
	insert into @ResultTable (AlertId, NeedAlertNum, LastUpdateTime) exec spGetNumOfNeedAlertV2 @WindowSize, @AId;

	set @WindowSize = 0;	
	set @NeedAlertNum = 0;
	----------------
	FETCH NEXT FROM @MonitorCursor INTO @AId;
	END	



	select * from @ResultTable
END
