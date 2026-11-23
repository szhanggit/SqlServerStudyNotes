
CREATE PROCEDURE dbo.spGetAcceptanceLoopIdByMerchant
@CategoryId INT = NULL,
@MerchantId INT
AS
BEGIN
	SET NOCOUNT ON;

select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopCategory alc with(nolock) on alc.AcceptanceLoopId = a.Id
where alc.CategoryId =@CategoryId and a.Status =1
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopMerchant alm with(nolock) on alm.AcceptanceLoopId = a.Id
where a.Status =1 and alm.MerchantId = @MerchantId
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopShop als with(nolock) on als.AcceptanceLoopId = a.Id
join Shop s with(nolock) on s.Id = als.ShopId
where a.Status =1 and s.Status =1 and s.MerchantId =@MerchantId
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopShop als with(nolock) on als.AcceptanceLoopId = a.Id
join Shop s with(nolock) on s.Id = als.ShopId
join Terminal t with(nolock) on t.ShopId = s.Id
where a.Status =1 and s.Status =1 and t.MerchantId =@MerchantId and t.Status =1

END;
