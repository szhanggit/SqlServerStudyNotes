
CREATE PROCEDURE spCheckBizAPI
AS
BEGIN
DECLARE @BatchName varchar(100);
declare @Id int;
Set @BatchName = 'CheckBizAPI'
select  @Id = max(Id) from APILog with(nolock);
select @BatchName as [Name],Count(1) asResult from APILog with(nolock)
where (ResponseCode ='9999' or ResponseCode is null) AND Id > @Id - 10000

END
