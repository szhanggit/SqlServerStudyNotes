
CREATE PROCEDURE CheckEMV
AS
BEGIN
DECLARE @BatchName varchar(100);
Set @BatchName = 'CheckEMV'

select @BatchName as [Name],count(1) as Result
from EMV_ClientOrderLine with(nolock)
where [Status] = 3 and Id>2904 and CreatedTime<DATEADD(HOUR,-3, GETDATE())
END
