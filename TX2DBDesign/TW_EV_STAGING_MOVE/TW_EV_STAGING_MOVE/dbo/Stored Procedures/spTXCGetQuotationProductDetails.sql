
CREATE PROCEDURE [dbo].[spTXCGetQuotationProductDetails]
	@QuotationNumber VARCHAR(50),
	@QuotationId INT = NULL,
	@ProductCode VARCHAR(50)
AS
BEGIN

SELECT
	cqp.Id,
	cq.Id ClientQuotationId,
	cq.QuotationNumber,
	pv.Id ProductVersionId,
	p.ProductCode,
	p.ProductName,
	cqp.ExpirySchemeId,
	cqp.ExpirationDate,
	cqp.MaxIssueVoucherNumber
FROM ClientQuotation cq
INNER JOIN ClientQuotationProduct cqp ON cq.Id = cqp.ClientQuotationId
INNER JOIN ProductVersion pv ON cqp.ProductVersionId = pv.Id
INNER JOIN Product p ON pv.ProductId = p.Id
WHERE (cq.QuotationNumber = @QuotationNumber OR cq.Id = @QuotationId)
AND p.ProductCode = @ProductCode

END
