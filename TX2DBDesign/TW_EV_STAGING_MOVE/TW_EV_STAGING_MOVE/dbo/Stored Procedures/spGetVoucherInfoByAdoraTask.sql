CREATE PROCEDURE spGetVoucherInfoByAdoraTask
	@AdoraTaskId	bigint
AS
BEGIN
    declare @IsNotifyClient bit
	declare @ClientNotificationProviderCode varchar(50)
	declare @AccountNumber varchar(50)
           
	select @IsNotifyClient = isnull(c.Neednotification,0),
	       @ClientNotificationProviderCode = d.Name,
		   @AccountNumber = o.OrderNumber
	from adoratask at with(nolock) join [order] o on at.orderid = o.id
	     join clientquotation cq with(nolock) on o.clientquotationid = cq.id
		 join client c with(nolock) on cq.clientid = c.id
		 left join dictionary d with(nolock) on c.NotificationProviderCodeId = d.id
	where at.id = @AdoraTaskId
    
	select vo.orderid        as OrderId,
	       p.id              as AcceptanceLoopExternalId,
	       @AccountNumber     as ExternalOrderId,
	       v.vouchernumber   as AccountNumber,
		   v.vouchernumber   as AccountNumberHashed,
		   obi.ActiveDate    as ActiveDate,		   
		   IIF((ISNULL(ep.Type, 0) = 6 or ISNULL(ep.Type, 0) = 7 or ISNULL(ep.Type, 0) = 8), v.ExpiryDate, obi.ExpiryDate) as ExpiryDate,
		   CASE 
			WHEN p.ProductType = 1 THEN pppb.Balance
			WHEN p.ProductType = 2 THEN
				CASE p.ProductSubType
					WHEN 4 THEN obi.FaceValueWithTax
					ELSE ppvb.FaceValueWithTax
				END
			ELSE 1 
		   END as BalanceAvailable,
		   obi.ExpirySchemeId as ExpirationPolicyExternalId,
		   p.id              as ProductExternalId,
		   pg.IdentityCode   as ProgramIdentityCode,
		   pg.Id 		     as ProgramId,
		   p.id              as RestrictionExternalId,
		   v.GUID            as AccountGuid,
		   p.producttype     as ValueType,
		   @IsNotifyClient   as IsNotifyClient,
		   @ClientNotificationProviderCode as ClientNotificationProviderCode,
		   isnull(m.AdoraMemberId,0) as MemberId,
		   p.ProductCode,
		   v.Id AS VoucherId,
		   v.ExtendId as ExtendId,
		   p.VoucherSupplierId,
		   v.PinCode,
		   cq.FinanceExpireDays,
		   p.ProductIssuerType,
		   ep.Type as ExpirationPolicyType,
		   ep.ValidPeriod,
		   ep.IsEndOfDay,
		   p.RequireExpiryDate,
		   p.VoucherNumberGenerateWay
	from voucherorder vo with(nolock)
	     join adoratask at with(nolock) on vo.adorataskid = at.id
	     join orderline ol with(nolock) on vo.orderlineid = ol.id
		 join [Order] o with(nolock) on ol.OrderId = o.Id
		 join OrderBeneficiaryInfo obi with(nolock) on vo.OrderBeneficiaryInfoId = obi.id
		 left join member m with(nolock) on obi.memberid = m.id
		 join clientquotationproduct cqp with(nolock) on ol.clientquotationproductid = cqp.id
		 JOIN dbo.ClientQuotation cq with(nolock) ON cq.Id = cqp.ClientQuotationId
		 join productversion pv with(nolock) on cqp.productversionid = pv.id
		 join product p with(nolock) on pv.productid = p.id
		 join program pg with(nolock) on p.programid = pg.id
		 left join ProductPricingValueBased ppvb with(nolock) on pv.productpricingvaluebasedid = ppvb.id
		 left join ProductPricingProductBased pppb with(nolock) on pv.ProductPricingProductBasedId = pppb.id
		 left join EXT_IN_APIOrderInfo emv with(nolock) on obi.Id = emv.OrderBeneficiaryInfoId and emv.OrderNumber = o.OrderNumber
		 join voucher v with(nolock) on vo.voucherid = v.id and (v.VSessionId = at.SessionId OR (obi.Memo = emv.RCN and o.[Status] = 32))
		 LEFT JOIN dbo.ExpirationPolicy AS ep WITH(NOLOCK) ON ep.Id = obi.ExpirySchemeId

	where at.id = @AdoraTaskId    
END