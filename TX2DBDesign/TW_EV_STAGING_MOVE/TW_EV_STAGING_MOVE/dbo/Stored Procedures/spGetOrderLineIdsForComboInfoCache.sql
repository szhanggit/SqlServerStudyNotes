CREATE PROCEDURE [dbo].[spGetOrderLineIdsForComboInfoCache] 
AS
BEGIN
	SET NOCOUNT ON;
	
	select ol.Id
From Product ps WITH(NOLOCK)
join ProductVersion pvs with(nolock) on pvs.ProductId = ps.Id
join ClientQuotationProduct cqp with(nolock) on cqp.ProductVersionId = pvs.Id
JOIN OrderLine ol with(nolock) on ol.ClientQuotationProductId = cqp.Id
join [Order] o with(nolock) on o.Id = ol.OrderId
JOIN ClientQuotationProductCombo cqpc WITH(NOLOCK) ON cqpc.ClientQuotationProductId = cqp.Id
where ps.IsMasterProduct = 1 and o.Status = 64 and o.PublishDatetime > DATEADD(day,-180,GETDATE())
group by ol.Id
having count(1)>3
order by ol.Id desc

END
