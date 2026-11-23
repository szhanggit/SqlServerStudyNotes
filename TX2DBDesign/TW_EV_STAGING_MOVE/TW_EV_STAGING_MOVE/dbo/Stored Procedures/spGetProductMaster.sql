
create procedure spGetProductMaster @QuotationNumber VARCHAR(50), @OrderNumber VARCHAR(50) = NULL
as
BEGIN
	set nocount on;

	IF @OrderNumber IS NULL
	BEGIN
		SELECT	p.ProductCode ProductInternalCode,
				p.ExternalProductCode ProductExternalCode,
				p.ProductName ProductName,
				p.ExpirationDate ExpiryDate,
				(SELECT	e.Id ExpirySchemeCode,
						e.[Type] ExpiryDateType,
						d.[Name] ExpiryCondition,	
						e.ValidPeriod ExpiryInMonths
					FROM dbo.ExpirationPolicy e JOIN dbo.ProductExpirySchemeSet s ON s.ExpirationPolicyId = e.Id
					JOIN dbo.Dictionary d ON e.DisplayNameId = d.Id 
					WHERE s.ProductExpirySchemeId = p.ProductExpirySchemeId FOR XML PATH('INExpiryPolicyInfo'),ROOT('RootNode')) ExpiryPolicyListObject
			FROM dbo.Product p 
			JOIN	dbo.ProductVersion pv ON pv.ProductId = p.Id
			JOIN	dbo.ClientQuotationProduct cqp ON cqp.ProductVersionId = pv.Id
			JOIN	dbo.ClientQuotation cq ON cq.Id = cqp.ClientQuotationId
			WHERE cq.QuotationNumber = @QuotationNumber
	END
	ELSE
	BEGIN
		SELECT	p.ProductCode ProductInternalCode,
				p.ExternalProductCode ProductExternalCode,
				p.ProductName ProductName,
				p.ExpirationDate ExpiryDate,
				(SELECT	e.Id ExpirySchemeCode,
						e.[Type] ExpiryDateType,
						d.[Name] ExpiryCondition,	
						e.ValidPeriod ExpiryInMonths
					FROM dbo.ExpirationPolicy e JOIN dbo.ProductExpirySchemeSet s ON s.ExpirationPolicyId = e.Id
					JOIN dbo.Dictionary d ON e.DisplayNameId = d.Id 
					WHERE s.ProductExpirySchemeId = p.ProductExpirySchemeId FOR XML PATH('INExpiryPolicyInfo'),ROOT('RootNode')) ExpiryPolicyListObject
			FROM dbo.Product p 
			JOIN	dbo.ProductVersion pv ON pv.ProductId = p.Id
			JOIN	dbo.ClientQuotationProduct cqp ON cqp.ProductVersionId = pv.Id
			JOIN	dbo.ClientQuotation cq ON cq.Id = cqp.ClientQuotationId
			JOIN	dbo.[Order] o ON o.ClientQuotationId = cq.Id
			WHERE cq.QuotationNumber = @QuotationNumber AND o.OrderNumber = @OrderNumber;
	END
end
