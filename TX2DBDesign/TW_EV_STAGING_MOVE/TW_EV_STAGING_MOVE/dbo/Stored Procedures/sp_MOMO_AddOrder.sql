CREATE PROCEDURE sp_MOMO_AddOrder
    @QuotationNumber VARCHAR(50) ,
    @MasterProductCode VARCHAR(50) ,
    @ChildProductCode VARCHAR(50),
	@TrustAccountId INT,
	@ApplyExpiryId INT = NULL,
    @ApplyExpiryDate DATETIME = NULL
AS
BEGIN


declare @OrderId int
declare @ChildQuotaionProductId int
declare @ChildProductId int
declare @ChildProductVersionId int
declare @ChildProductProductComboSetId int
declare @ChildOrderLineId int
declare @TrustAcountAmonut numeric(20,6)

declare @ProductEmailTemplateVersionId int
declare @OrderEmailTemplateVersionId int
declare @OrderEmailTemplateTagValueId int

declare @ProductSLMSTemplateVersionId int
declare @OrderSLMSTemplateVersionId int
declare @OrderSLMSTemplateTagValueId int

select @ChildProductId = Id from Product with(nolock) where ProductCode = @ChildProductCode
select @ChildProductVersionId = Id,@ProductEmailTemplateVersionId = ProductEmailTemplateVersionId,@ProductSLMSTemplateVersionId= ProductSLMSTemplateVersionId from ProductVersion with(nolock) where ProductId = @ChildProductId and IsCurrentVersion = 1

select @ChildProductProductComboSetId = pcs.Id from Product p with(nolock) 
join ProductVersion pv with(nolock) on pv.ProductId = p.Id
join ProductComboSet pcs with(nolock) on pcs.ProductComboId = pv.ProductComboId
where p.ProductCode = @MasterProductCode and pv.IsCurrentVersion = 1 and ChildProductId = @ChildProductId


select top 1 @OrderId = ol.OrderId from Product p with(nolock) 
join ProductVersion pv with(nolock) on pv.ProductId = p.Id
join ClientQuotationProduct cqp with(nolock) on pv.Id = cqp.ProductVersionId
join ClientQuotation cq with(nolock) on cq.Id = cqp.ClientQuotationId
join ClientQuotationProductCombo cqpc with(nolock) on cqpc.ClientQuotationProductId = cqp.Id
join ClientQuotationProduct cqpccc with(nolock) on cqpc.ChildClientQuotationProductId = cqpccc.Id
join OrderLine ol with(nolock) on ol.ClientQuotationProductId = cqpccc.Id
where p.ProductCode = @MasterProductCode and cq.QuotationNumber = @QuotationNumber

select top 1 @ChildQuotaionProductId = cqpccc.Id from Product p with(nolock) 
join ProductVersion pv with(nolock) on pv.ProductId = p.Id
join ClientQuotationProduct cqp with(nolock) on pv.Id = cqp.ProductVersionId
join ClientQuotation cq with(nolock) on cq.Id = cqp.ClientQuotationId
join ClientQuotationProductCombo cqpc with(nolock) on cqpc.ClientQuotationProductId = cqp.Id
join ClientQuotationProduct cqpccc with(nolock) on cqpc.ChildClientQuotationProductId = cqpccc.Id
join ProductVersion pvc with(nolock) on pvc.Id = cqpccc.ProductVersionId
join Product pc with(nolock) on pc.Id = pvc.ProductId
where p.ProductCode = @MasterProductCode and cq.QuotationNumber = @QuotationNumber and pc.ProductCode = @ChildProductCode

IF EXISTS(select 1 from OrderLine with(nolock) where OrderId = @OrderId and ClientQuotationProductId= @ChildQuotaionProductId)
BEGIN
RETURN;
END

BEGIN TRY
BEGIN TRAN
insert   into   OrderEmailTemplateVersion   default   values
select @OrderEmailTemplateVersionId = SCOPE_IDENTITY();
insert   into   OrderEmailTemplateTagValue   default   values
select @OrderEmailTemplateTagValueId = SCOPE_IDENTITY();

INSERT INTO [dbo].[OrderEmailTemplateTagValueSet]
           ([ContentTagId]
           ,[OrderEmailTemplateTagValueId]
           ,[Value])
select pvt.[ContentTagId],@OrderEmailTemplateTagValueId,pvt.[Value] from ProductEmailTemplateVersionSet petvs with(nolock)  
join ProductEmailContentTagValueSet pvt with(nolock) on pvt.ProductEmailTemplateTagValueId = petvs.EmailTemplateTagValueId
where petvs.ProductEmailTemplateVersionId = @ProductEmailTemplateVersionId

INSERT INTO [dbo].[OrderEmailTemplateVersionSet]
           ([OrderEmailTemplateVersionId]
           ,[EmailTemplateVersionId]
           ,[EmailTemplateTagValueId])
select @OrderEmailTemplateVersionId,petvs.EmailTemplateVersionId,@OrderEmailTemplateTagValueId from ProductEmailTemplateVersionSet petvs with(nolock)  
where petvs.ProductEmailTemplateVersionId = @ProductEmailTemplateVersionId

insert   into   OrderSLMSTemplateVersion   default   values
select @OrderSLMSTemplateVersionId = SCOPE_IDENTITY();
insert   into   OrderSLMSTemplateTagValue   default   values
select @OrderSLMSTemplateTagValueId = SCOPE_IDENTITY();

INSERT INTO [dbo].[OrderSLMSTemplateTagValueSet]
           ([ContentTagId]
           ,[OrderSLMSTemplateTagValueId]
           ,[Value])
select pvt.[ContentTagId],@OrderSLMSTemplateTagValueId,pvt.[Value] from ProductSLMSTemplateVersionSet petvs with(nolock)  
join ProductSLMSContentTagValueSet pvt with(nolock) on pvt.ProductSLMSTemplateTagValueId = petvs.SLMSTemplateTagValueId
where petvs.ProductSLMSTemplateVersionId = @ProductEmailTemplateVersionId

INSERT INTO [dbo].[OrderSLMSTemplateVersionSet]
           ([OrderSLMSTemplateVersionId]
           ,[SLMSTemplateVersionId]
           ,[SLMSTemplateTagValueId])
select @OrderSLMSTemplateVersionId,petvs.SLMSTemplateVersionId,@OrderSLMSTemplateTagValueId from ProductSLMSTemplateVersionSet petvs with(nolock)  
where petvs.ProductSLMSTemplateVersionId = @ProductSLMSTemplateVersionId

IF @ApplyExpiryId IS NULL
BEGIN
	DECLARE @did INT = (SELECT TOP 1 Id FROM dbo.Dictionary WITH(NOLOCK) WHERE Name = 'FixEndOfDay' AND Category = 'ExpirationPolicyName')
	SET @ApplyExpiryId = (SELECT TOP 1 Id FROM dbo.ExpirationPolicy WITH(NOLOCK) WHERE DisplayNameId = @did)
	SET @ApplyExpiryDate = '2999-12-31 23:59:59.000';
END

INSERT INTO [dbo].[OrderLine]
           ([OrderId]
           ,[ClientQuotationProductId]
           ,[TotalQuantity]
           ,[EmailQuantity]
           ,[SLMSQuantity]
           ,[EmailTemplateVersionId]
           ,[SLMSTemplateVersionId]
           ,[DefaultExpirationDate]
           ,[VoucherReservationCodeId]
           ,[NeedShortUrl]
           ,[Status]
           ,[ExpirationPolicyId]
           ,[MessageEncoding]
           ,[PublishedQuantity]
           ,[AdHocRuleProductId]
           ,[OrderEmailTemplateVersionId]
           ,[OrderSLMSTemplateVersionId]
           ,[NeedTrustAccount]
           ,[CancelledQuantity])
     VALUES(
	 @OrderId,
	 @ChildQuotaionProductId,
	 0,
	 0,
	 0,
	 null,
	 null,
	 @ApplyExpiryDate,
	 1,
	 1,
	 1,
	 @ApplyExpiryId,
	 null,
	 0,
	 null,
	 @OrderEmailTemplateVersionId,
	 @OrderSLMSTemplateVersionId,
	 0,
	 null
	 )

select @ChildOrderLineId = SCOPE_IDENTITY()

INSERT INTO [dbo].[OrderLineCombo]
           ([OrderLineId]
           ,[ProductComboSetId]
           ,[ExchangeTime])
		   values(
		   @ChildOrderLineId,
		   @ChildProductProductComboSetId,
		   GETDATE()
		   )

--Trust Account
IF @TrustAccountId > 0
BEGIN
	DECLARE @ExpiryPolicyId INT = (SELECT TOP 1 Id FROM dbo.TrustExpiryPolicy WITH(NOLOCK) WHERE IsDefault = 1);

	select @TrustAcountAmonut =
		case 
		when childP.ProductType =1 then cqpsp.SoldPriceWithTax*pppb.Balance*1.000000
		when childP.ProductType =2 then ppvb.FaceValueWithTax/100.000000
		else 0.000000 end
		FROM dbo.Product childP WITH(NOLOCK)
		JOIN dbo.ProductVersion childPV WITH(NOLOCK) ON childPV.ProductId = childP.Id AND childPV.IsCurrentVersion = 1
		JOIN dbo.ClientQuotationProduct childCqp WITH(NOLOCK) ON childCqp.ProductVersionId = childPV.Id
		JOIN dbo.ClientQuotationProductSoldPrice cqpsp WITH(NOLOCK) ON cqpsp.ClientQuotationProductId = childCqp.Id
		LEFT JOIN dbo.ProductPricingValueBased ppvb WITH(NOLOCK) ON ppvb.Id = childPV.ProductPricingValueBasedId
		LEFT JOIN dbo.ProductPricingProductBased pppb WITH(NOLOCK) ON pppb.Id = childPV.ProductPricingProductBasedId
		JOIN dbo.ClientQuotationProductCombo cqpCombo WITH(NOLOCK) ON cqpCombo.ChildClientQuotationProductId = childCqp.Id
		JOIN dbo.ClientQuotationProduct cqp WITH(NOLOCK) ON cqp.Id = cqpCombo.ClientQuotationProductId
		JOIN dbo.ClientQuotation cq WITH(NOLOCK) ON cq.Id = cqp.ClientQuotationId
		where cq.QuotationNumber = @QuotationNumber AND childP.ProductCode = @ChildProductCode

	INSERT dbo.OrderLineTrustAccount
	(
	    OrderLineId,
	    TrustAccountId,
	    TrustAccountOption,
	    TrustAccountBatchNo,
	    Amount,
	    ExpiryPolicyId,
	    ExpiryDate,
	    ValidFrom,
	    ValidTo
	)
	VALUES
	(   @ChildOrderLineId,         -- OrderLineId - int
	    @TrustAccountId,         -- TrustAccountId - int
	    0,         -- TrustAccountOption - int
	    N'',       -- TrustAccountBatchNo - nvarchar(200)
	    @TrustAcountAmonut,      -- Amount - numeric(20, 6)
	    @ExpiryPolicyId,         -- ExpiryPolicyId - int
	    NULL, -- ExpiryDate - datetime
	    CONVERT(DATE, GETDATE()), -- ValidFrom - datetime
	    DATETIMEFROMPARTS(2999,12,31,23,59,59,0)  -- ValidTo - datetime
	    )

	INSERT dbo.OrderLineTrustAccountHistory(
		OrderLineId, NeedTrustAccount, CreateTime, Creator, OrderLineTrustAccountId, 
		TrustAccountId, TrustAccountOption, TrustAccountBatchNo, Amount, ExpiryPolicyId, 
		ExpiryDate, ValidFrom, ValidTo)
	SELECT OrderLineId, 1, GETDATE(), 'SP', Id, 
		TrustAccountId, TrustAccountOption, TrustAccountBatchNo, Amount, ExpiryPolicyId, 
		ExpiryDate, ValidFrom, ValidTo 
	FROM dbo.OrderLineTrustAccount WHERE OrderLineId = @ChildOrderLineId
END


--INSERT INTO [dbo].[OrderLineTrustAccount]
--           ([OrderLineId]
--           ,[TrustAccountId]
--           ,[TrustAccountOption]
--           ,[TrustAccountBatchNo]
--           ,[Amount]
--           ,[ExpiryPolicyId]
--           ,[ExpiryDate]
--           ,[ValidFrom]
--           ,[ValidTo])
--select top 1  @ChildOrderLineId,o.TrustAccountId,o.TrustAccountOption,o.TrustAccountBatchNo,@TrustAcountAmonut,o.ExpiryPolicyId,o.ExpiryDate,o.ValidFrom,o.ValidTo
--from Product p with(nolock) 
--join ProductVersion pv with(nolock) on pv.ProductId = p.Id
--join ClientQuotationProduct cqp with(nolock) on pv.Id = cqp.ProductVersionId
--join ClientQuotation cq with(nolock) on cq.Id = cqp.ClientQuotationId
--join ClientQuotationProductCombo cqpc with(nolock) on cqpc.ClientQuotationProductId = cqp.Id
--join ClientQuotationProduct cqpccc with(nolock) on cqpc.ChildClientQuotationProductId = cqpccc.Id
--left join OrderLine ol with(nolock) on ol.ClientQuotationProductId = cqpccc.Id
--join OrderLineTrustAccount o with(nolock) on o.OrderLineId = ol.Id
--where p.ProductCode = @MasterProductCode and pv.IsCurrentVersion = 1 and cq.QuotationNumber = @QuotationNumber and o.ValidFrom<GETDATE() and o.ValidTo>GETDATE()
	END TRY
	BEGIN CATCH
		ROLLBACK;
		SELECT ERROR_MESSAGE();
	END CATCH

    IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;

END