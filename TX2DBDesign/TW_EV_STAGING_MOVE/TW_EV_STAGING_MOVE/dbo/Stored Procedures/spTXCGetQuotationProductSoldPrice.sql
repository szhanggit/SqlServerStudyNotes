
CREATE PROCEDURE [dbo].[spTXCGetQuotationProductSoldPrice]
	@QuotationNumber VARCHAR(50),
	@ProductCode VARCHAR(50)
AS
BEGIN

SELECT
	cqpsp.Id,
	cqp.Id ClientQuotationProductId,
	cqpsp.SoldPriceWithoutTax,
	cqpsp.SoldPriceWithTax,
	cqpsp.ValueBasedSoldPriceWithoutTax,
	cqpsp.ValueBasedSoldPriceWithTax,
	cqpsp.ValidityFrom,
	cqpsp.ValidityEnd,
	cqpsp.Status,
	cqpsp.CreatedBy,
	cqpsp.CreatedOn,
	cqpsp.ApprovedBy,
	cqpsp.ApprovedOn,
	cqpsp.SoldPricePercentage,
	cqpsp.FaceValueRangeFrom,
	cqpsp.FaceValueRangeTo
FROM ClientQuotation cq
INNER JOIN ClientQuotationProduct cqp ON cq.Id = cqp.ClientQuotationId
INNER JOIN ClientQuotationProductSoldPrice cqpsp ON cqp.Id = cqpsp.ClientQuotationProductId
INNER JOIN ProductVersion pv ON cqp.ProductVersionId = pv.Id
INNER JOIN Product p ON pv.ProductId = p.Id
WHERE cq.QuotationNumber = @QuotationNumber
AND p.ProductCode = @ProductCode

END
