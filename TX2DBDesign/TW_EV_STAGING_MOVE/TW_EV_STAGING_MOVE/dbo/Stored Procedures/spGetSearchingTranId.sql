
CREATE PROCEDURE dbo.spGetSearchingTranId
@SeekingDateTime datetime
,@TranId INT OUTPUT
AS
    SET NOCOUNT ON

    DECLARE	@PivotDateTime datetime;
    declare @TimeDiffInSec bigint;
    declare @MaxId bigint = 0;
    declare @MinId bigint = 0;
    declare @PivotId bigint = 0;
    declare @MinDateTime datetime;
    declare @MaxDateTime datetime;
    select @MaxId = max(Id) from [Transaction] with(nolock)
    select @MinId = max(Id) - 10000 from [Transaction] with(nolock)
    select @MaxDateTime = TranLocalDateTime from [Transaction] with(nolock) where Id = @MaxId
    select @MinDateTime = TranLocalDateTime from [Transaction] with(nolock) where Id = @MinId
    declare @FinalId bigint;

    if(@SeekingDateTime is null)
    begin
        set @TranId = -1;
    end
    else if(@SeekingDateTime < @MinDateTime)
    begin
        set @TranId = -1;
    end
    else if(@SeekingDateTime > @MaxDateTime)
    begin
        set @TranId = -1;
    end
    else
    begin
		WHILE (1=1)              
		BEGIN


		 set @PivotId = (@MaxId + @MinId)/2
		 EXEC	[dbo].[spGetTranPivotDateTime]
				@MaxId = @MaxId,
				@MinId = @MinId,
				@PivotDateTime = @PivotDateTime OUTPUT


		SELECT @TimeDiffInSec = DATEDIFF(ss, @PivotDateTime, @SeekingDateTime);


		if(@TimeDiffInSec > 0)
		begin
			if(abs(@TimeDiffInSec) < 10)
			begin
				set @FinalId = (@MaxId + @MinId)/2;
				break;
			end

			set @MinId = @PivotId;
		end
		else
		begin
			if(abs(@TimeDiffInSec) < 100)
			begin
				set @FinalId = (@MaxId + @MinId)/2;
				break;
			end
	
			set @MaxId = @PivotId;
		end


		END
		set @TranId = @FinalId;
    end
