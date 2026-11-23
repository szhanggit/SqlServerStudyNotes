
CREATE PROCEDURE [dbo].[spTXCGetQuotationProductServiceFeeTriggerTime]
	@QuotationNumber VARCHAR(50),
	@ProductCode VARCHAR(50)
AS
BEGIN

SELECT
	sftt.ServiceFeeTriggerTimeId,
	sftt.SoldPrice,
	sftt.SoldPriceWithTax,
	sftt.ValidityFrom,
	sftt.ValidityEnd ValidityTo,
	sftt.Status
FROM ClientQuotation cq
INNER JOIN ClientQuotationProduct cqp ON cq.Id = cqp.ClientQuotationId
INNER JOIN ClientQuotationProductServiceFeeTriggerTime sftt ON cqp.Id = sftt.ClientQuotationProductId
INNER JOIN ProductVersion pv ON cqp.ProductVersionId = pv.Id
INNER JOIN Product p ON pv.ProductId = p.Id
WHERE cq.QuotationNumber = @QuotationNumber
AND p.ProductCode = @ProductCode

END
