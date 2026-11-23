
CREATE PROCEDURE spCheckClientQuotationProductSoldPrice
AS
BEGIN
DECLARE @BatchName varchar(100);
Set @BatchName = 'CheckClientQuotationProductSoldPrice'

select @BatchName as [Name],count(1) as Result
from(select ClientQuotationProductId, COUNT(1) as temp from ClientQuotationProductSoldPrice with(nolock)
where ValidityFrom<GETDATE() and ValidityFrom >GETDATE()
group by ClientQuotationProductId 
having count(1)>1) as tt

END
