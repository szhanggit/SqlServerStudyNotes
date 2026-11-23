
CREATE PROCEDURE [dbo].[spCheckVoucherQuantity]
	@OrderNumber VARCHAR(50)
	,@ProductCode VARCHAR(50)
	,@ConsumerCode VARCHAR(50)
	,@AvailableQuantity INT OUTPUT
	,@Price NUMERIC(15, 4) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @MaxIssueVoucherNumber INT
	DECLARE @TotalQuantity INT
	DECLARE @ClientQuotationProductId INT
	DECLARE @CurrentDateTime DATETIME = GETDATE()

	SELECT @MaxIssueVoucherNumber = cqp.MaxIssueVoucherNumber
		,@Price = CQPSP.SoldPriceWithoutTax
		,@ClientQuotationProductId = cqp.Id
	FROM OrderLine ol WITH (NOLOCK)
	INNER JOIN [Order] o WITH (NOLOCK) ON ol.OrderId = o.Id
	INNER JOIN ClientQuotationProduct cqp WITH (NOLOCK) ON ol.ClientQuotationProductId = cqp.Id
	INNER JOIN ProductVersion pv WITH (NOLOCK) ON cqp.ProductVersionId = pv.Id
	INNER JOIN Product p WITH (NOLOCK) ON pv.ProductId = p.Id
	INNER JOIN ClientQuotation cq WITH (NOLOCK) ON cqp.ClientQuotationId = cq.Id
	INNER JOIN Client c WITH (NOLOCK) ON cq.ClientId = c.Id
	INNER JOIN ClientQuotationProductSoldPrice CQPSP WITH (NOLOCK) ON cqp.Id = CQPSP.ClientQuotationProductId
	WHERE o.OrderNumber = @OrderNumber
		AND p.ProductCode = @ProductCode
		AND c.IdentityCode = @ConsumerCode
		AND o.Mode = 2
		AND CQPSP.ValidityFrom <= @CurrentDateTime
		AND CQPSP.ValidityEnd >= @CurrentDateTime
		AND CQPSP.[Status] = 2

	IF ISNULL(@MaxIssueVoucherNumber, 0) > 0
	BEGIN
		SELECT @TotalQuantity = sum(ol.TotalQuantity)
		FROM OrderLine ol WITH (NOLOCK)
		INNER JOIN [Order] o WITH (NOLOCK) ON ol.OrderId = o.Id
		WHERE ol.ClientQuotationProductId = @ClientQuotationProductId
			AND o.STATUS > 4

		SET @AvailableQuantity = @MaxIssueVoucherNumber - @TotalQuantity
	END
END
