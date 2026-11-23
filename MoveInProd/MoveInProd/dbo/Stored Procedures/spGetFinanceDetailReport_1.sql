
CREATE PROCEDURE [dbo].[spGetFinanceDetailReport]
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
      

select * from (select ROW_NUMBER() OVER (ORDER by OrderNumber) AS RowNum,BusinessModelId AS FT, OrderNumber,Cost,TranType,MerchantName,ProductName,count(VoucherNumber) as Quan from 
(
	
SELECT Distinct VoucherNumber,BusinessModelId,TranType,MerchantName,ProductName,OrderNumber,Cost
FROM (
SELECT         Voucher.VoucherNumber, BusinessModelId,
                            CASE [Transaction].TranType WHEN 101 THEN 'Redemption' ELSE 'ReverseRedemption' END AS TranType, 
							 CASE Product .ProductType WHEN 1 THEN
                                (SELECT          isnull(pppb.FaceValue, 0) / 100
                                  FROM               ProductPricingProductBased pppb
                                  WHERE           pppb.Id = ProductPricingProductBasedId) ELSE
                                ((SELECT          isnull(ppvb.FaceValue, 0) / 100
                                    FROM              ProductPricingValueBased ppvb
                                    WHERE          ppvb.Id = ProductPricingValueBasedId) *
                                (SELECT          isnull(Value, 0)
                                  FROM               ReimbursementScheme rs
                                  WHERE           rs.MerchantContractId = MerchantContract.Id AND rs.TransactionTypeId = '71')) / 100 END AS Cost, 

                            [Order].OrderNumber, Product.ProductName, Merchant.Name AS MerchantName
FROM              MerchantContract INNER JOIN
                            Merchant ON MerchantContract.MerchantId = Merchant.Id RIGHT OUTER JOIN
                            Product INNER JOIN
                            ProductVersion INNER JOIN
                            Voucher INNER JOIN
                            OrderBeneficiaryInfo ON Voucher.BeneficiaryInfoId = OrderBeneficiaryInfo.Id ON 
                            ProductVersion.Id = OrderBeneficiaryInfo.ProductVersionId INNER JOIN
                            OrderLine ON OrderBeneficiaryInfo.OrderLineId = OrderLine.Id ON Product.Id = Voucher.ProductId INNER JOIN
                            [Order] ON OrderLine.OrderId = [Order].Id INNER JOIN
                            [Transaction] ON Voucher.VoucherNumber = [Transaction].AccountNumber RIGHT OUTER JOIN
                            Program ON Voucher.ProgramId = Program.Id AND [Transaction].ProgramCode = Program.IdentityCode ON 
                            MerchantContract.ProductVersionId = ProductVersion.Id LEFT OUTER JOIN
                            ClientQuotation ON [Order].ClientQuotationId = ClientQuotation.Id
WHERE          (Voucher.Status IN (32, 2)) AND ([Transaction].TranType IN (101, 201)) AND ([Transaction].ResponseCode = '0000') AND TranLocalDateTime BETWEEN @startDate AND @endDate + '  23:59:59'
							) BaseData 
							GROUP BY  VoucherNumber,BusinessModelId,TranType,MerchantName,ProductName,OrderNumber,Cost



	)as FF1
	GROUP by OrderNumber,BusinessModelId,TranType,MerchantName,ProductName,Cost
) FF
where FF.RowNum between @startPage and @endPage
END

