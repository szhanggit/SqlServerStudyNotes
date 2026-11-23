CREATE PROCEDURE [dbo].[spGetMosConsumeReport]
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
	
SELECT Distinct VoucherNumber,ProductName,Id,Cost,MAX(TranLocalDateTime) as TranLocalDateTime
FROM (
SELECT          ProductVersion.Id, Voucher.VoucherNumber, Product.ProductName, CASE Product .ProductType WHEN 1 THEN
                          (SELECT dbo.F_GetReimbursementValueByProductID(Voucher.ProductId))
						    ELSE
                                ((SELECT          isnull(ppvb.FaceValue, 0) / 100
                                    FROM              ProductPricingValueBased ppvb
                                    WHERE          ppvb.Id = ProductPricingValueBasedId) *
                                (SELECT dbo.F_GetReimbursementValueByProductID(Voucher.ProductId))) / 100 END AS Cost, 
                            [Transaction].TranLocalDateTime, [Transaction].Id AS Expr1
FROM              Product RIGHT OUTER JOIN
                            Voucher ON Product.Id = Voucher.ProductId LEFT OUTER JOIN
                            Program LEFT OUTER JOIN
                            [Transaction] ON Program.IdentityCode = [Transaction].ProgramCode ON 
                            Voucher.VoucherNumber = [Transaction].AccountNumber AND Voucher.ProgramId = Program.Id LEFT OUTER JOIN
                            OrderBeneficiaryInfo LEFT OUTER JOIN
                            OrderLine LEFT OUTER JOIN
                            [Order] LEFT OUTER JOIN
                            ClientQuotation ON [Order].ClientQuotationId = ClientQuotation.Id ON OrderLine.OrderId = [Order].Id ON 
                            OrderBeneficiaryInfo.OrderLineId = OrderLine.Id LEFT OUTER JOIN
                            ProductVersion ON OrderBeneficiaryInfo.ProductVersionId = ProductVersion.Id ON 
                            Voucher.BeneficiaryInfoId = OrderBeneficiaryInfo.Id
WHERE          (Voucher.Status = '32') AND ([Transaction].MerchantId = 7)

AND    (ClientQuotation.BusinessModelId IN (1, 2, 3, 4, 7, 8)) AND  (TranType = '101') AND (ResponseCode = '0000') AND TranLocalDateTime BETWEEN @startDate AND @endDate + '  23:59:59'
							) BaseData 
							GROUP BY VoucherNumber,ProductName,Id,Cost,TranLocalDateTime 


	)as FF1
	GROUP by ProductName,Id
) FF
where FF.RowNum between @startPage and @endPage
END