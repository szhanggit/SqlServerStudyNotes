
CREATE PROCEDURE [dbo].[spTXCGetQuotationProducts]
	@QuotationNumber VARCHAR(50),
	@QuotationId INT = NULL,
	@Keyword NVARCHAR(MAX) = NULL,
	@PageSize INT = 20,
	@PageIndex INT = 0,
	@TotalCount INT = 0 OUTPUT
AS
BEGIN

	DECLARE @QuotationProductList TABLE
	(
		Id INT NOT NULL
	)

	INSERT INTO @QuotationProductList
	SELECT
		cqp.Id
	FROM ClientQuotation cq
	INNER JOIN ClientQuotationProduct cqp ON cq.Id = cqp.ClientQuotationId
	INNER JOIN ProductVersion pv ON cqp.ProductVersionId = pv.Id
	INNER JOIN Product p ON pv.ProductId = p.Id
	WHERE (cq.QuotationNumber = @QuotationNumber OR cq.Id = @QuotationId)
	AND (@Keyword IS NULL OR p.ProductCode = @Keyword OR p.ProductName = @Keyword)

	SELECT @TotalCount = COUNT(1) FROM @QuotationProductList

	SELECT
		cqp.Id,
		cq.Id ClientQuotationId,
		pv.Id ProductVersionId,
		p.ProductCode,
		p.ProductName,
		cqp.ExpirySchemeId,
		cqp.ExpirationDate,
		cqp.MaxIssueVoucherNumber
	FROM @QuotationProductList qp
	INNER JOIN ClientQuotationProduct cqp ON qp.Id = cqp.Id
	INNER JOIN ClientQuotation cq ON cqp.ClientQuotationId = cq.Id
	INNER JOIN ProductVersion pv ON cqp.ProductVersionId = pv.Id
	INNER JOIN Product p ON pv.ProductId = p.Id
	ORDER BY cqp.Id
	OFFSET (@PageSize * @PageIndex) ROWS
	FETCH NEXT @PageSize ROWS ONLY
END
