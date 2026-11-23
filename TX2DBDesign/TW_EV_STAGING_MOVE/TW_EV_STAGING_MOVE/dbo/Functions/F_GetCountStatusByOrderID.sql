CREATE function [dbo].[F_GetCountStatusByOrderID] (@OrderID int,@Status int)
returns int
as
begin
declare @resultCount int
SELECT       @resultCount= Count(VoucherNumber) FROM   OrderBeneficiaryInfo LEFT OUTER JOIN  Voucher ON OrderBeneficiaryInfo.Id = Voucher.BeneficiaryInfoId RIGHT OUTER JOIN
             OrderLine ON OrderBeneficiaryInfo.OrderLineId = OrderLine.Id RIGHT OUTER JOIN   [Order] ON OrderLine.OrderId = [Order].Id WHERE [Order].Id=@OrderID AND Voucher.Status=@Status
return @resultCount
end
 