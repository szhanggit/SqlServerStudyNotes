CREATE PROCEDURE dbo.spGetExpirationPolicyHistory

	@ClientQuotationProductId int

AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT 
        eph.ClientQuotationProductId, 
        eph.ClientQuotationProductComboId, 
        COALESCE(p.ProductCode,'') as ChildProductCode,
        eph.VersionNo, 
        eph.ExpirySchemeId, 
        d.DisplayName as ExpirationPolicyDisplayName,
        eph.ExpirationDate, 
        eph.CreatedTime, 
        eph.CreatedBy
    FROM ExpirationPolicyHistory eph with(nolock)
        join ExpirationPolicy ep with(nolock) on eph.ExpirySchemeId = ep.Id
        join Dictionary d with(nolock) on ep.DisplayNameId = d.Id
        left join ClientQuotationProductCombo cqpc with(nolock) on eph.ClientQuotationProductComboId = cqpc.Id
        left join ProductComboSet pcs with(nolock) on cqpc.ProductComboSetId = pcs.Id
        left join Product p with(nolock) on pcs.ChildProductId = p.Id
    WHERE eph.ClientQuotationProductId = @ClientQuotationProductId

END