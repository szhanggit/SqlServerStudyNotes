CREATE PROCEDURE [dbo].[spGetBillingReport]
	--@startPage int,
 --   @endPage int,
	@startDate nvarchar(200),
    @endDate nvarchar(200),
	@ContactName nvarchar(200),
	@OrderNumber nvarchar(200)
AS
     
BEGIN
  
 Declare @sqlstring nvarchar(3000)
 Declare @sqlstring2 nvarchar(400)
 Declare @sqlstring3 nvarchar(400)
 Declare @sqlstring4 nvarchar(100)
 SET @endDate=  @endDate +' 23:59:59 ' 
set @sqlstring= '	
SELECT  DISTINCT OrderNumber,PublishDatetime,ContactName,MerchantName,ProductName,FaceValue,ProductCode,ActiveCount,UsedCount,ExpireCount,TrashCount
FROM (
SELECT          [Order].OrderNumber, [Order].PublishDatetime, ProductVersion.ProductName, Product.ProductCode, 
                            ClientQuotation.ContactName, CASE ProductType WHEN 1 THEN
                                (SELECT          isnull(pppb.FaceValue, 0) / 100
                                  FROM               ProductPricingProductBased pppb
                                  WHERE           pppb.Id = ProductPricingProductBasedId) ELSE
                                (SELECT          isnull(ppvb.FaceValue, 0) / 100
                                  FROM               ProductPricingValueBased ppvb
                                  WHERE           ppvb.Id = ProductPricingValueBasedId) END AS FaceValue, 
                            dbo.F_GetCountStatusByOrderID([Order].Id, 2) AS ActiveCount, dbo.F_GetCountStatusByOrderID([Order].Id, 32) 
                            AS UsedCount, dbo.F_GetCountStatusByOrderID([Order].Id, 4) AS ExpireCount, 
                            dbo.F_GetCountStatusByOrderID([Order].Id, 8) AS TrashCount, Merchant.Name AS MerchantName
FROM              ClientQuotationProduct LEFT OUTER JOIN
                            Merchant RIGHT OUTER JOIN
                            MerchantContract ON Merchant.Id = MerchantContract.MerchantId RIGHT OUTER JOIN
                            ProductVersion ON MerchantContract.ProductVersionId = ProductVersion.Id ON 
                            ClientQuotationProduct.ProductVersionId = ProductVersion.Id LEFT OUTER JOIN
                            Product AS Product ON ProductVersion.ProductId = Product.Id RIGHT OUTER JOIN
                            OrderLine RIGHT OUTER JOIN
                            ClientQuotation RIGHT OUTER JOIN
                            [Order] ON ClientQuotation.Id = [Order].ClientQuotationId ON OrderLine.OrderId = [Order].Id ON 
                            ClientQuotationProduct.Id = OrderLine.ClientQuotationProductId 
							WHERE PublishDatetime BETWEEN '''  + @startDate+''' AND '''+ @endDate + ''''
--if(@ContactName<>'')
--	SET @sqlstring2 = 'AND  (ContactName like ISNULL(N''%'+@ContactName+'%'' , ContactName) or  ISNULL(N''%'+@ContactName+'%'' , ContactName) like ContactName)'
--if(@OrderNumber<>'')
--	SET @sqlstring3 = ' AND OrderNumber like ISNULL(N''%'+@OrderNumber+'%'' , OrderNumber) '						
							
							
						
							
						SET @sqlstring4	= ' )  BaseData 	GROUP BY OrderNumber,PublishDatetime,ContactName,MerchantName,ProductName,FaceValue,ProductCode,ActiveCount,UsedCount,ExpireCount,TrashCount '
--EXEC (@sqlstring+@sqlstring2+@sqlstring3+@sqlstring4)
Print @sqlstring+@sqlstring2+@sqlstring3+@sqlstring4
END