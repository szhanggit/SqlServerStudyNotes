
CREATE PROCEDURE [dbo].[spInvoiceTransactionReport] @InvoiceId BIGINT = NULL
	,@InvoiceRequestedId BIGINT = NULL
	,@ITBRId BIGINT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT c.NAME AS ClientName
		,d1.DisplayName AS BusinessModel
		,o.OrderName AS OrderName
		,p.ProductName AS ProductName
		,p.ProductCode as ProductCode
		,m.NAME AS MerchantName
		,obi.ClientOrderNumber AS ClientOrderNo
		,t.AccountNumber AS VoucherNo
		,t.InvoiceValue AS SettleAmount
		,d2.DisplayName AS TransactionType
		,t.TranLocalDateTime AS TransactionDateTime
		,o.PublishDatetime AS IssueDateTime
		,s.NAME AS ShopName
		,obi.Email AS BenificiaryEmail
		,obi.Mobile AS BenificiaryMobile
		,t.SettleDate As SettleDate
	FROM [Transaction] t
	LEFT JOIN InvoiceToBeRequested itbr ON t.InvoiceToBeRequestedId = itbr.Id
	LEFT JOIN InvoiceRequested ir ON itbr.InvoiceRequestedId = ir.Id
	LEFT JOIN Invoice i ON itbr.InvoiceRequestedId = i.InvoiceRequestedId
	LEFT JOIN ClientQuotationProduct cqp ON t.ClientQuotationProductId = cqp.Id
	LEFT JOIN ClientQuotation cq ON cqp.ClientQuotationId = cq.Id
	LEFT JOIN Client c ON cq.ClientId = c.Id
	LEFT JOIN BusinessModel bm ON cq.BusinessModelId = bm.Id
	LEFT JOIN Dictionary d1 ON bm.DisplayNameId = d1.Id
	LEFT JOIN Dictionary d2 ON t.TranType = d2.NAME
		AND d2.Category = 'TransactionType'
	LEFT JOIN [Order] o ON t.OrderId = o.Id
	LEFT JOIN Product p ON t.ProductId = p.Id
	LEFT JOIN Merchant m ON t.MerchantId = m.Id
	LEFT JOIN Shop s ON t.ShopId = s.Id
	LEFT JOIN Program pg ON pg.Id = t.ProgramCode
	LEFT JOIN Voucher v ON t.AccountNumber = v.VoucherNumber
		AND pg.Id = v.ProgramId
	LEFT JOIN OrderBeneficiaryInfo obi ON v.BeneficiaryInfoId = obi.Id
	WHERE NOT (
			@InvoiceId IS NULL
			AND @ITBRId IS NULL
			AND @InvoiceRequestedId IS NULL
			)
		AND (
			@InvoiceId IS NULL
			OR i.Id = @InvoiceId
			)
		AND (
			@InvoiceRequestedId IS NULL
			OR ir.Id = @InvoiceRequestedId
			)
		AND (
			@ITBRId IS NULL
			OR itbr.Id = @ITBRId
			)
		AND (
			i.[Status] IS NULL
			OR i.[Status] = 1
			)
		AND t.ResponseCode = '0000'
END

