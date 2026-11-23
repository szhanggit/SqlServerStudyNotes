
CREATE PROCEDURE dbo.spGetAcceptanceLoopIdByMerchantCategory
@CategoryId INT
AS
BEGIN
	SET NOCOUNT ON;

	select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopCategory alc with(nolock) on alc.AcceptanceLoopId = a.Id
where alc.CategoryId =@CategoryId and a.Status =1
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopMerchant alm with(nolock) on alm.AcceptanceLoopId = a.Id
join Merchant m with(nolock) on m.Id = alm.MerchantId
where a.Status =1 and m.Status =1 and m.CategoryId =@CategoryId
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopShop als with(nolock) on als.AcceptanceLoopId = a.Id
join Shop s with(nolock) on s.Id = als.ShopId
join Merchant m with(nolock) on m.Id = s.MerchantId
where a.Status =1 and s.Status =1 and m.CategoryId =@CategoryId and m.Status =1
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopShop als with(nolock) on als.AcceptanceLoopId = a.Id
join Shop s with(nolock) on s.Id = als.ShopId
join Terminal t with(nolock) on t.ShopId = s.Id
join Merchant m with(nolock) on m.Id = t.MerchantId
where a.Status =1 and s.Status =1 and m.CategoryId =@CategoryId and m.Status =1 and t.Status =1

END;
