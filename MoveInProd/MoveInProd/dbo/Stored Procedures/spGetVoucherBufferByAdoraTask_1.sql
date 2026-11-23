CREATE PROCEDURE spGetVoucherBufferByAdoraTask
	@AdoraTaskId	bigint
AS
BEGIN
	SET NOCOUNT ON;
    declare @IsNotifyClient bit
	declare @ClientNotificationProviderCode varchar(50)
	declare @AccountNumber varchar(50)
           
	select @IsNotifyClient = isnull(c.Neednotification,0),
	       @ClientNotificationProviderCode = d.Name,
		   @AccountNumber = o.OrderNumber
	from adoratask at WITH(NOLOCK)
		 join [order] o WITH(NOLOCK) on at.orderid = o.id
	     join clientquotation cq WITH(NOLOCK) on o.clientquotationid = cq.id
		 join client c WITH(NOLOCK) on cq.clientid = c.id
		 left join dictionary d WITH(NOLOCK) on c.NotificationProviderCodeId = d.id
	where at.id = @AdoraTaskId
    
	select vo.orderid        as OrderId,
	       p.id              as AcceptanceLoopExternalId,
	       @AccountNumber     as ExternalOrderId,
	       v.vouchernumber   as AccountNumber,
		   v.vouchernumber   as AccountNumberHashed,
		   obi.ActiveDate    as ActiveDate,
		   IIF(ISNULL(ep.Type, 0) = 6, v.ExpiryDate, obi.ExpiryDate) as ExpiryDate,
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
		   p.ProductIssuerType
	from dbo.VoucherOrderBuffer vo WITH(NOLOCK)
	     join adoratask at WITH(NOLOCK) on vo.adorataskid = at.id
	     join orderline ol WITH(NOLOCK) on vo.orderlineid = ol.id
		 join OrderBeneficiaryInfo obi WITH(NOLOCK) on vo.OrderBeneficiaryInfoId = obi.id
		 left join member m WITH(NOLOCK) on obi.memberid = m.id
		 join clientquotationproduct cqp WITH(NOLOCK) on ol.clientquotationproductid = cqp.id
		 JOIN dbo.ClientQuotation cq WITH(NOLOCK) ON cq.Id = cqp.ClientQuotationId
		 join productversion pv WITH(NOLOCK) on cqp.productversionid = pv.id
		 join product p WITH(NOLOCK) on pv.productid = p.id
		 join program pg WITH(NOLOCK) on p.programid = pg.id
		 left join ProductPricingValueBased ppvb WITH(NOLOCK) on pv.productpricingvaluebasedid = ppvb.id
		 left join ProductPricingProductBased pppb WITH(NOLOCK) on pv.ProductPricingProductBasedId = pppb.id
		 join dbo.VoucherBuffer v WITH(NOLOCK) on vo.voucherid = v.id and v.VSessionId = at.SessionId
		 LEFT JOIN dbo.ExpirationPolicy AS ep WITH(NOLOCK) ON ep.Id = obi.ExpirySchemeId

	where at.id = @AdoraTaskId    
END
