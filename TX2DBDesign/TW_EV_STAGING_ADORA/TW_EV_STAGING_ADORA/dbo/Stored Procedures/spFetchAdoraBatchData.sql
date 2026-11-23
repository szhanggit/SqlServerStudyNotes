
CREATE PROCEDURE dbo.spFetchAdoraBatchData
@BatchName varchar(100),
@BatchType int,
@ExecutePeriod float
AS
    SET NOCOUNT ON
	DECLARE @dt DateTime;
	DECLARE @diff float = 0;
	DECLARE @IsGood int = 0;
	select top 1 @dt = StartTime from Batch with(nolock) where BatchType = @BatchType order by Id desc
	select @dt = dateadd(HOUR, 8, @dt)
	
	set @diff = DATEDIFF(hour, @dt, getdate());
	if(@diff <= @ExecutePeriod)
	begin
		set @IsGood = 1;
	end
	else
	begin
		set @IsGood = 0;
	end

	select @BatchType as BatchType,  @BatchName as BatchName, @dt as ExecuteStartTime, @ExecutePeriod as ExecutePeriod, 8 as [Status], @diff as Diff, @IsGood as IsGood;
