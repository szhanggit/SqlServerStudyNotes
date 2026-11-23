CREATE function [dbo].[F_GetReimbursementValueByProductID] (@ProductID int)
returns float
as
begin
declare @resultCount float
SELECT     @resultCount=  isnull(ReimbursementScheme.Value,0) FROM   ReimbursementScheme RIGHT OUTER JOIN
                            MerchantContract ON ReimbursementScheme.MerchantContractId = MerchantContract.Id RIGHT OUTER JOIN
                            ProductVersion ON MerchantContract.ProductVersionId = ProductVersion.Id
							WHERE TransactionTypeId=71 AND GETDATE() BETWEEN MerchantContract.ValidFrom AND MerchantContract.ValidTo
							AND ProductId=@ProductID

return @resultCount
end
 