
CREATE PROCEDURE dbo.spGetTranPivotDateTime
@MaxId bigint,
@MinId bigint,
@PivotDateTime datetime OUTPUT
AS
    SET NOCOUNT ON
    declare @PivotId bigint = 0;
    set @PivotId = (@MaxId + @MinId)/2

    select @PivotDateTime = TranLocalDateTime from [Transaction] with(nolock) where Id = @PivotId
