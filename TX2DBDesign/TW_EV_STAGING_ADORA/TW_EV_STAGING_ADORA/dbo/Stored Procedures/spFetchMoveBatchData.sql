
CREATE PROCEDURE dbo.spFetchMoveBatchData
@BatchName varchar(100),
@ExecutePeriod float
AS
    SET NOCOUNT ON
	DECLARE @dt DateTime;
	DECLARE @diff float = 0;
	DECLARE @IsGood int = 0;
	select top 1 @dt = ExecuteStartTime from BatchLog with(nolock) 
	where [Status] = 8 AND BatchName = @BatchName
	order by Id desc;

	set @diff = DATEDIFF(hour, @dt, getdate());
	if(@diff <= @ExecutePeriod)
	begin
		set @IsGood = 1;
	end
	else
	begin
		set @IsGood = 0;
	end

	select @BatchName as BatchName, @dt as ExecuteStartTime, @ExecutePeriod as ExecutePeriod, 8 as [Status], @diff as Diff, @IsGood as IsGood;
