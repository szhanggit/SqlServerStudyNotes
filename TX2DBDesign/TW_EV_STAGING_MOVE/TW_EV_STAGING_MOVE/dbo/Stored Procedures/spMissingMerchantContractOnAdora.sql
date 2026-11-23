CREATE PROCEDURE [dbo].[spMissingMerchantContractOnAdora]
AS
BEGIN

select mc.Id as ExternalId, m.IdentityCode as MerchantCode, p.Id as ProductExternalId, pg.IdentityCode as ProgramCode, Convert(CHAR(8),mc.ValidFrom,112) as StartDate, Convert(CHAR(8),mc.ValidTo,112) as EndDate
from TW_EV_UAT_MOVE.dbo.MerchantContract mc with(nolock)
inner join TW_EV_UAT_MOVE.dbo.ProductVersion pv with(nolock) on mc.ProductVersionId = pv.Id
inner join TW_EV_UAT_MOVE.dbo.Product p with(nolock) on pv.ProductId = p.Id
inner join TW_EV_UAT_MOVE.dbo.Merchant m with(nolock) on mc.MerchantId = m.Id
inner join TW_EV_UAT_MOVE.dbo.Program pg with(nolock) on p.ProgramId = pg.Id
left join TW_EV_UAT_ADORA.dbo.MerchantContract amc with(nolock) on mc.Id = amc.ExternalId
where mc.ValidFrom <= GETDATE() AND mc.ValidTo >= GETDATE() AND amc.Id is null AND p.[Status] = 1

END