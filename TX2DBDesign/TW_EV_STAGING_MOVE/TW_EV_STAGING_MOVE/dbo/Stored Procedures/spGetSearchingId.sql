create PROCEDURE [dbo].[spGetSearchingId]
@SeekingDateTime datetime
AS
    SET NOCOUNT ON

    DECLARE	@PivotDateTime datetime;
    declare @TimeDiffInSec bigint;
    declare @MaxId bigint = 0;
    declare @MinId bigint = 0;
    declare @PivotId bigint = 0;
    declare @MinDateTime datetime;
    declare @MaxDateTime datetime;
    select @MaxId = max(Id) from APILog with(nolock)
    select @MinId = min(Id) from APILog with(nolock)
    select @MaxDateTime = CreatedOn from APILog with(nolock) where Id = @MaxId
    select @MinDateTime = CreatedOn from APILog with(nolock) where Id = @MinId
    declare @FinalId bigint;

    if(@SeekingDateTime is null)
    begin
        select 'The input date cannot be null.';
    end
    else if(@SeekingDateTime < @MinDateTime)
    begin
        select 'The input date is too small.'
    end
    else if(@SeekingDateTime > @MaxDateTime)
    begin
        select 'The input date is too big.'
    end
    else
    begin
		WHILE (1=1)              
		BEGIN


		 set @PivotId = (@MaxId + @MinId)/2
		 EXEC	[dbo].[spGetPivotDateTime]
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
		select @FinalId;
    end