
CREATE PROCEDURE dbo.spFetchDiveEmailData
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

insert into @table_variable_name (Id, TaskId, MessageStatus, MessageLocalId, CreatedOn, SentOn, Comment)
select top 1000 Id, TaskId, MessageStatus, MessageLocalId, CreatedOn, SentOn, Comment from EmailMessage with(nolock) order by Id desc

select * from @table_variable_name where MessageStatus != 3 AND Comment not like '%success%'


