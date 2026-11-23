
CREATE PROCEDURE [dbo].[spGetMosExpiredNotConsumeReport]
	@startPage int,
    @endPage int,
	@startDate nvarchar(200),
    @endDate nvarchar(200)    
AS
     
BEGIN
   --if len(@startDate)=0 or @startDate=''
   --   set @startDate='1900/01/01'
   --if len(@endDate)=0 or @startDate=''
   --   set @endDate =''+convert(nvarchar(4),year(getdate()))+'/'+convert(nvarchar(4),month(getdate()))+'/'+convert(nvarchar(2),day(getdate()))      
      

select ProductName,Quan,cost from (select ROW_NUMBER() OVER (ORDER by ProductName) AS RowNum, Id,ProductName,count(VoucherNumber) as Quan,sum(cast(Cost as int))as cost from 
(
	
SELECT Distinct VoucherNumber,ProductName,Id,Cost
FROM (
SELECT   Voucher.VoucherNumber, Product.ProductName, Product.Id, CASE Product .ProductType WHEN 1 THEN
                                (SELECT          dbo.F_GetReimbursementValueByProductID(Voucher.ProductId)) ELSE
                                ((SELECT          isnull(ppvb.FaceValue, 0) / 100
                                    FROM              ProductPricingValueBased ppvb
                                    WHERE          ppvb.Id = ProductPricingValueBasedId) *
                                (SELECT          dbo.F_GetReimbursementValueByProductID(Voucher.ProductId))) / 100 END AS Cost
FROM              OrderLine LEFT OUTER JOIN
                            [Order] LEFT OUTER JOIN
                            ClientQuotation ON [Order].ClientQuotationId = ClientQuotation.Id ON OrderLine.OrderId = [Order].Id RIGHT OUTER JOIN
                            OrderBeneficiaryInfo LEFT OUTER JOIN
                            ProductVersion ON OrderBeneficiaryInfo.ProductVersionId = ProductVersion.Id ON 
                            OrderLine.Id = OrderBeneficiaryInfo.OrderLineId FULL OUTER JOIN
                            Voucher FULL OUTER JOIN
                            AcceptanceLoop LEFT OUTER JOIN
                            Product ON AcceptanceLoop.Id = Product.AcceptanceLoopId RIGHT OUTER JOIN
                            AcceptanceLoopMerchant ON AcceptanceLoop.Id = AcceptanceLoopMerchant.AcceptanceLoopId RIGHT OUTER JOIN
                            Merchant ON AcceptanceLoopMerchant.MerchantId = Merchant.Id ON Voucher.ProductId = Product.Id ON 
                            OrderBeneficiaryInfo.Id = Voucher.BeneficiaryInfoId							
WHERE          (Voucher.Status = 2 OR
                            Voucher.Status = 4) AND (Merchant.Id = 7) AND (ClientQuotation.BusinessModelId IN (1, 2, 3, 4, 7, 8)) AND Voucher.ExpiryDate BETWEEN @startDate AND @endDate + '  23:59:59'
							) BaseData 
							GROUP BY VoucherNumber,ProductName,Id,Cost 
	)as FF1
	GROUP by ProductName,Id
) FF
where FF.RowNum between @startPage and @endPage
END

