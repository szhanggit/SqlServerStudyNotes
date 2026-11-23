
CREATE PROCEDURE dbo.spQueryQuotationProductList @QuotationNumber VARCHAR(50), @PageIndex INT, @PageSize INT, @TotalCount INT, @TotalCountOut INT OUTPUT
AS 
BEGIN
	SET NOCOUNT ON;

    SELECT p.ProductCode
		FROM dbo.ClientQuotation cq WITH(NOLOCK)
			 INNER JOIN dbo.ClientQuotationProduct cqp WITH(NOLOCK) ON cqp.ClientQuotationId = cq.Id
			 INNER JOIN dbo.ProductVersion pv WITH(NOLOCK) ON pv.Id = cqp.ProductVersionId
			 INNER JOIN dbo.Product p WITH(NOLOCK) ON p.Id = pv.ProductId
		WHERE cq.QuotationNumber = @QuotationNumber
		ORDER BY p.ProductCode OFFSET(@PageIndex-1)* @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;

	SET @TotalCountOut = @TotalCount;

    IF @TotalCount=0 
	BEGIN
        SELECT @TotalCountOut = COUNT(*) 
			FROM dbo.ClientQuotation cq WITH(NOLOCK)
            JOIN dbo.ClientQuotationProduct cqp WITH(NOLOCK) ON cqp.ClientQuotationId = cq.Id
			WHERE cq.QuotationNumber = @QuotationNumber;
    END
END

