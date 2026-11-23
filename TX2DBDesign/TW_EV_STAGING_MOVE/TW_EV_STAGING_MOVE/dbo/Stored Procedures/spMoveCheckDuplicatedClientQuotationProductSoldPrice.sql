CREATE PROCEDURE [dbo].[spMoveCheckDuplicatedClientQuotationProductSoldPrice]      
AS      
BEGIN  

SET NOCOUNT ON

SELECT TOP 1 * 
FROM (SELECT *,
	ROW_NUMBER() OVER(PARTITION BY ClientQuotationProductId, SoldPriceWithoutTax, SoldPriceWithTax, ValidityFrom, ValidityEnd, [Status] ORDER BY Id) rownum
	FROM ClientQuotationProductSoldPrice WITH(NOLOCK) WHERE [Status] = 2) temp
WHERE temp.rownum > 1

END