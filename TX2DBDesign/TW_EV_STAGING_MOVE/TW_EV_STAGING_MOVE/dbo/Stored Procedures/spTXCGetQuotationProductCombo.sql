
CREATE PROCEDURE [dbo].[spTXCGetQuotationProductCombo]
	@QuotationNumber VARCHAR(50),
	@ProductCode VARCHAR(50)
AS
BEGIN

SELECT
	cqpc.Id,
	cqp.Id ClientQuotationProductId,
	cqpc.ProductComboSetId,
	cqpc.ExpirySchemeId,
	cqpc.ExpirationDate,
	cqpc.ChildClientQuotationProductId,
	childcq.Id as ChildClientQuotationId,
	cqpc.BusinessModelId,
	cqpc.Sequence,
	cqpc.CustomizationProductId,
	cqpc.LastUpdateDate,
	cqpc.UpdatedBy
FROM ClientQuotation cq
INNER JOIN ClientQuotationProduct cqp ON cq.Id = cqp.ClientQuotationId
INNER JOIN ClientQuotationProductCombo cqpc ON cqp.Id = cqpc.ClientQuotationProductId
INNER JOIN ClientQuotationProduct childcqp with(nolock) on cqpc.ChildClientQuotationProductId = childcqp.Id
INNER JOIN ClientQuotation childcq with(nolock) on childcqp.ClientQuotationId = childcq.Id
INNER JOIN ProductVersion pv ON cqp.ProductVersionId = pv.Id
INNER JOIN Product p ON pv.ProductId = p.Id
WHERE cq.QuotationNumber = @QuotationNumber
AND p.ProductCode = @ProductCode

END
