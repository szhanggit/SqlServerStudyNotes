CREATE PROCEDURE [dbo].[spGetEMV_TaskInfo] 
	@IsNew BIT
AS
BEGIN
	SET NOCOUNT ON;

update 
EMV_ClientOrderLine set Status=2
where Id in (
select ecol.Id from 
EMV_ClientOrderLine ecol with(nolock)
left join EMV_VoucherClientOrder v with(nolock) on v.ClientOrderLineId = ecol.Id
left join EXT_IN_APIOrderInfo ext with(nolock) on ext.RCN=ecol.RCN
where ecol.status = 1 and ecol.CreatedTime< DATEADD(HOUR,-2,GETDATE())
group by ecol.Id
having COUNT(v.Id) =0 and Count(ext.Id)=0)

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
		,col.ClientOrderNumber
		,col.DeliveryType
		,pv.ProductName
		,col.OrderNumber	
	FROM [dbo].[EMV_ClientOrderLine] AS col WITH(NOLOCK)
	JOIN [dbo].[EMV_ClientOrder] AS co WITH(NOLOCK) on co.Id = col.ClientOrderId
	JOIN [dbo].[ClientQuotationProduct] AS cqp WITH(NOLOCK) on cqp.Id = col.ClientQuotationProductId
	JOIN [dbo].[ClientQuotation] cq WITH(NOLOCK) on cqp.ClientQuotationId = cq.Id
	JOIN [dbo].[Client] c WITH(NOLOCK) on cq.ClientId = c.Id
	JOIN [dbo].[ProductVersion] pv WITH(NOLOCK) on pv.Id = cqp.ProductVersionId
	JOIN [dbo].[ProgramVoucherRoute] pvr WITH(NOLOCK) on pvr.ProgramId = pv.ProgramId
	JOIN [dbo].[Product] p WITH(NOLOCK) on p.Id = pv.ProductId
	Left join EXT_IN_APIOrderInfo ee with(nolock) on ee.RCN = col.RCN
	WHERE ((@IsNew =1 AND col.[Status]=1) OR (@IsNew =0 AND col.[Status] BETWEEN 2 AND 4))and ee.RCN is null
			and c.CanIssue = 1 and p.CanIssue = 1
END