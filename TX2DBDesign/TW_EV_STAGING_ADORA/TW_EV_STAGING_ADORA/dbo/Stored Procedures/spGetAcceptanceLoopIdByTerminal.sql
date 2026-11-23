
CREATE PROCEDURE dbo.spGetAcceptanceLoopIdByTerminal
@ShopId INT = NULL,
@MerchantId INT = NULL
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
join AcceptanceLoopMerchant alm with(nolock) on alm.AcceptanceLoopId = a.Id
join Merchant m with(nolock) on m.Id = alm.MerchantId
join Shop s with(nolock) on s.MerchantId = m.Id
where a.Status =1 and m.Status = 1 and s.Status = 1 and s.Id = @ShopId
union
select a.Id from AcceptanceLoop a with(nolock)
join AcceptanceLoopShop als with(nolock) on als.AcceptanceLoopId = a.Id
join Shop s with(nolock) on s.Id = als.ShopId
where a.Status =1 and s.Status =1 and s.Id = @ShopId

END;
