
CREATE PROCEDURE [dbo].[spGetCampaignReport]
	@startPage int,
    @endPage int,
	@startDate nvarchar(200),
    @endDate nvarchar(200)    
AS
     
BEGIN

select * from (select ROW_NUMBER() OVER (ORDER by ClientName) AS RowNum, ClientName,ProductName,TotalQuantity,PublishDatetime,BusinessModelId,SoldPrice,OrderName from 
(
	
SELECT  *
FROM (
SELECT       Client.Name as ClientName , [Order].OrderName, ProductVersion.ProductName,
                                (SELECT          SUM(TotalQuantity) AS Expr1
                                  FROM               OrderLine
                                  WHERE           (OrderId = [Order].Id)) AS TotalQuantity, [Order].PublishDatetime, ClientQuotation.BusinessModelId, 
                            ClientQuotationProduct.SoldPrice
FROM              Client RIGHT OUTER JOIN
                            ClientQuotation ON Client.Id = ClientQuotation.ClientId LEFT OUTER JOIN
                            ProductVersion RIGHT OUTER JOIN
                            ClientQuotationProduct ON ProductVersion.Id = ClientQuotationProduct.ProductVersionId ON 
                            ClientQuotation.Id = ClientQuotationProduct.ClientQuotationId RIGHT OUTER JOIN
                            [Order] ON ClientQuotation.Id = [Order].ClientQuotationId
WHERE          ([Order].PublishDatetime BETWEEN @startDate AND @endDate + '  23:59:59')	
							) BaseData 
						


	)as FF1
	
) FF
where FF.RowNum between @startPage and @endPage
END

