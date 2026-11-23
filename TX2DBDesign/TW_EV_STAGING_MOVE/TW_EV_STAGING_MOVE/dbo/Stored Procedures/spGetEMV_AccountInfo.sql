
CREATE PROCEDURE spGetEMV_AccountInfo
     @ClientOrderLineId INT
AS
BEGIN
     select
          p.id              as AcceptanceLoopExternalId,
          cov.vouchernumber   as AccountNumber,
          cov.vouchernumber   as AccountNumberHashed,
          case when p.producttype = 1 then pppb.Balance
           else ppvb.FaceValueWithTax
           end as BalanceAvailable,
          p.id              as ProductExternalId,
          pg.IdentityCode   as ProgramIdentityCode,
          p.id              as RestrictionExternalId,
          cov.GUID            as AccountGuid,
          p.producttype     as ValueType,
          cq.FinanceExpireDays as FinanceExpireDays
     from EMV_ClientOrderLine ol 
          join EMV_VoucherClientOrder cov on cov.clientOrderLineId = ol.id
          join clientquotationproduct cqp on ol.clientquotationproductid = cqp.id
          JOIN ClientQuotation cq ON cq.Id = cqp.ClientQuotationId
          join productversion pv on cqp.productversionid = pv.id
          join product p on pv.productid = p.id
          join program pg on p.programid = pg.id
          left join ProductPricingValueBased ppvb on pv.productpricingvaluebasedid = ppvb.id
          left join ProductPricingProductBased pppb on pv.ProductPricingProductBasedId = pppb.id
          --LEFT JOIN dbo.ExpirationPolicy AS ep WITH(NOLOCK) ON ep.Id = obi.ExpirySchemeId
     where ol.Id = @ClientOrderLineId
END
