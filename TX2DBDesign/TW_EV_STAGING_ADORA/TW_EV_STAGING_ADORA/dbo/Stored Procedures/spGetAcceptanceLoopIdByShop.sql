
CREATE PROCEDURE dbo.spGetAcceptanceLoopIdByShop
@ShopId INT,
@MerchantId INT
AS
BEGIN
	SET NOCOUNT ON;
	
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopCategory alc with(nolock) on alc.AcceptanceLoopId = a.Id
join MerchantCategory mc with(nolock) on mc.Id = alc.CategoryId
join Merchant m with(nolock) on m.CategoryId = mc.Id
where a.Status =1 and m.Status = 1 and mc.Status = 1 and m.Id =@MerchantId
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopMerchant alm with(nolock) on alm.AcceptanceLoopId = a.Id
join Merchant m with(nolock) on m.Id = alm.MerchantId
where a.Status =1 and m.Status = 1 and m.Id = @MerchantId
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopShop als with(nolock) on als.AcceptanceLoopId = a.Id
where a.Status =1 and als.ShopId = @ShopId
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopCategory alc with(nolock) on alc.AcceptanceLoopId = a.Id
join MerchantCategory mc with(nolock) on mc.Id = alc.CategoryId
join Merchant m with(nolock) on m.CategoryId = mc.Id
join Terminal t with(nolock) on t.MerchantId = m.Id
where a.Status =1 and m.Status = 1 and mc.Status = 1 and t.Status = 1 and t.ShopId =@ShopId
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopMerchant alm with(nolock) on alm.AcceptanceLoopId = a.Id
join Merchant m with(nolock) on m.Id = alm.MerchantId
join Terminal t with(nolock) on t.MerchantId = m.Id
where a.Status =1 and m.Status = 1 and t.Status=1 and m.Id = @MerchantId

END;
