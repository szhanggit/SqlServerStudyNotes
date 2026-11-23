create PROCEDURE [dbo].[spGetPivotDateTime]
@MaxId bigint,
@MinId bigint,
@PivotDateTime datetime OUTPUT
AS
    SET NOCOUNT ON
    declare @PivotId bigint = 0;
    set @PivotId = (@MaxId + @MinId)/2

    select @PivotDateTime = CreatedOn from ApiLog with(nolock) where Id = @PivotId
