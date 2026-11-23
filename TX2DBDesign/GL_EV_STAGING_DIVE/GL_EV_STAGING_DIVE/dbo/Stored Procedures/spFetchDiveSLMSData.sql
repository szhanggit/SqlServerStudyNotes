
CREATE PROCEDURE dbo.spFetchDiveSLMSData
AS
DECLARE @table_variable_name TABLE (
    Id int null,
	TaskId int null,
	MessageStatus int null,
	MessageLocalId int null,
	CreatedOn DateTime null,
	SentOn DateTime null,
	Comment varchar(1000) null
);

Declare @SearchDate DateTime = getDate();
SELECT @SearchDate = DATEADD(Day, -7, @SearchDate); 

insert into @table_variable_name (Id, TaskId, MessageStatus, MessageLocalId, CreatedOn, SentOn, Comment)
select top 1000 Id, TaskId, MessageStatus, MessageLocalId, CreatedOn, SentOn, Comment from SLMSMessage with(nolock) 
where CreatedOn >= @SearchDate
order by Id desc

select * from @table_variable_name where MessageStatus != 3 AND Comment not like '%success%'


