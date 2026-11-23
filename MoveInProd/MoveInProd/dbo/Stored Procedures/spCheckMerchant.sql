CREATE PROCEDURE [dbo].spCheckMerchant
AS
BEGIN
    SET NOCOUNT ON
DECLARE @BatchName varchar(100);
Set @BatchName = 'CheckMerchant'

select @BatchName as [Name],count(1) as Result
from Merchant sm with(nolock)
left join IN_EV_PROD_ADORA.dbo.Merchant sa with(nolock) on sa.IdentityCode = sm.IdentityCode and sm.Status = sa.Status
where sm.Status>0 and sa.Id is null
END
