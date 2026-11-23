
CREATE PROCEDURE [dbo].[spGetEMV_TaskInfo] 
	@IsNew BIT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		col.ClientOrderId
		,col.Id as ClientOrderLineId
		,col.ClientQuotationProductId
		,col.RCN
		,col.Quantity
		,col.Priority
		,pvr.VoucherStockTableName
		,pvr.ShortUrlPrefix as ShortUrlPrefix
		,pv.ProductId
		,col.CreatedTime
		,col.[Status] as ClientOrderLineStatus
		,col.SKU
		,pv.ProductName
	FROM [dbo].[EMV_ClientOrderLine] AS col WITH(NOLOCK)
	JOIN [dbo].[EMV_ClientOrder] AS co WITH(NOLOCK) on co.Id = col.ClientOrderId
	JOIN [dbo].[ClientQuotationProduct] AS cqp WITH(NOLOCK) on cqp.Id = col.ClientQuotationProductId
	JOIN [dbo].[ProductVersion] pv WITH(NOLOCK) on pv.Id = cqp.ProductVersionId
	JOIN [dbo].[ProgramVoucherRoute] pvr WITH(NOLOCK) on pvr.ProgramId = pv.ProgramId
	Left join EXT_IN_APIOrderInfo ee with(nolock) on ee.RCN = col.RCN
	WHERE ((@IsNew =1 AND col.[Status]=1) OR (@IsNew =0 AND col.[Status] BETWEEN 2 AND 4))and ee.RCN is null
END
