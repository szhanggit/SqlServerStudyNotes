CREATE PROCEDURE [dbo].[spGetUserRateByExpireDateReport]
	@startPage int,
    @endPage int,
	@startDate nvarchar(200),
    @endDate nvarchar(200),
	@MerchantId int    
AS
     
BEGIN

select * from (select ROW_NUMBER() OVER (ORDER by Name) AS RowNum, Name as ClientName,OrderName,ProductName,TotalQuantity,ConsumeCount,
Cast(round(Cast((ConsumeCount)as float)/   
NULLIF((TotalQuantity),0),3)*100 AS NVARCHAR(5))+'%' as userate ,DefaultExpirationDate,PublishDatetime from 
(
	
SELECT  *
FROM (


SELECT          Client.Name, ProductVersion.ProductName,OrderName,
                                (SELECT          SUM(TotalQuantity) AS Expr1
                                  FROM               OrderLine
                                  WHERE           (OrderId = [Order].Id)) AS TotalQuantity,
                                (SELECT          COUNT(Voucher.VoucherNumber) AS Expr1
                                  FROM               [Order] AS O2 LEFT OUTER JOIN
                                                              OrderLine AS OL2 LEFT OUTER JOIN
                                                              OrderBeneficiaryInfo LEFT OUTER JOIN
                                                              Voucher ON OrderBeneficiaryInfo.Id = Voucher.BeneficiaryInfoId ON 
                                                              OL2.Id = OrderBeneficiaryInfo.OrderLineId ON O2.Id = OL2.OrderId
                                  WHERE           (O2.Id = [Order].Id) AND (Voucher.Status = 32)) AS ConsumeCount, [Order].PublishDatetime, 
                            ClientQuotationProduct.ExpirationDate, OrderLine_1.DefaultExpirationDate
FROM              ClientQuotationProduct LEFT OUTER JOIN
                            MerchantContract RIGHT OUTER JOIN
                            ProductVersion ON MerchantContract.ProductVersionId = ProductVersion.Id ON 
                            ClientQuotationProduct.ProductVersionId = ProductVersion.Id RIGHT OUTER JOIN
                            Client RIGHT OUTER JOIN
                            ClientQuotation ON Client.Id = ClientQuotation.ClientId RIGHT OUTER JOIN
                            OrderLine AS OrderLine_1 RIGHT OUTER JOIN
                            [Order] ON OrderLine_1.OrderId = [Order].Id ON ClientQuotation.Id = [Order].ClientQuotationId ON 
                            ClientQuotationProduct.ClientQuotationId = ClientQuotation.Id
WHERE          (MerchantContract.MerchantId = @MerchantId) AND ([Order].PublishDatetime BETWEEN @startDate AND 
                            @endDate + '  23:59:59') AND  
							 DefaultExpirationDate BETWEEN @startDate AND @endDate + '  23:59:59'
							-- [Order].PublishDatetime BETWEEN @startDate AND @endDate + '  23:59:59'

							) BaseData 
						


	)as FF1
	
) FF
where FF.RowNum between @startPage and @endPage
END