Create PROCEDURE [dbo].[spGetVouchersForDownload2]
 @OrderNumber varchar(50)
AS 
BEGIN
	
	DECLARE @DefaultLanguageId INT
	SELECT @DefaultLanguageId = CAST([NAME] AS INT) FROM  dbo.Dictionary WHERE Category = 'DefaultLanguageId'

	SELECT o.OrderNumber,
		   v.VoucherNumber,
		   p.ProductName, 
		   ob.Mobile, 
		   ob.Email,
		   ob.ActiveDate,
		   ob.[Memo],
		   v.GUID,
		   CASE WHEN ol.NeedShortUrl = 1 THEN v.ShortUrl ELSE NULL END VoucherAlias,
		   CASE WHEN ol.NeedShortUrl = 1 THEN v.AuthCode ELSE NULL END AuthCode,
		   ob.Name,
		   ob.Address,
		   ob.PostCode,
		   ob.ClientOrderNumber,
		   ob.EDOrderNumber,
		   o.OrderName,
		   ob.ExpiryDate as defaultExpiryDate,
		   ob.FaceValueWithTax,
		   p.ProductCode,
		   ep.Type as ExpirationPolicyType,
		   ep.IsEndOfDay as ExpirationPolicyIsEndOfDay,
		   ep.ValidPeriod as ExpirationPolicyValidPeriod,
		   isnull(case when ol.[OrderSLMSTemplateVersionId] is not null then 
								case when st1.id is not null then st1.Content1
									 when st2.id is not null then st2.Content1
									 else '' end
					   when ol.SLMSTemplateVersionId is not null then st.Content1
					   else '' end ,'') as Content,
		   ob.OrderLineId,
           case when ol.[OrderSLMSTemplateVersionId] is not null then tx.Product_Name
				when ol.SLMSTemplateVersionId is not null then tt.Product_Name				
				else '' end as CTProductName,
		   case when ol.[OrderSLMSTemplateVersionId] is not null then tx.SMSGreetings
				when ol.SLMSTemplateVersionId is not null then tt.SMSGreetings
				else '' end as SMSGreeting,
		   sb.DownloadURL as Starbucks_DownloadURL,
		   sb.AuthCode as Starbucks_AuthCode,
		   sb.ExpiryDate as Starbucks_ExpiryDate,
		   sb.QRCode as Starbucks_QRCode,
		   pro.IdentityCode as ProgramCode,
		   vnr.VoucherGenerator,
		   v.PinCode,
		   CASE WHEN ep.IsEndOfDay = 1 THEN pro.DateFormatString ELSE pro.DateTimeFormatString END ProgramDateTimeFormatString,
		   v.[Status],
		   v.LastTranOn,
		   o.PublishDatetime,
		   vsn.SequenceNumber,
		   ext_gr_v.ExpiryDate as TPCExpiryDate,
		   p.VoucherSupplierId,
		   ext_ob.MemberId,
		   ext_ob.VoucherHistoryId,
		   p.VoucherNumberGenerateWay,
                   v.ExpiryDate as ReferenceExpiryDate
	FROM	[Order] o WITH(NOLOCK)			
			join OrderLine ol WITH(NOLOCK) on ol.OrderId = o.Id
			join OrderBeneficiaryInfo ob WITH(NOLOCK) on ob.OrderLineId = ol.Id
			left join EXT_SG_OrderBeneficiaryInfo ext_ob on ext_ob.id = ob.id
			join Voucher v WITH ( NOLOCK ) on v.BeneficiaryInfoId=ob.Id
			left join EXT_GR_VoucherInfo ext_gr_v with(nolock) on v.ExtendId = ext_gr_v.Id
			join [dbo].[VoucherReservationBatch] as vrb WITH(NOLOCK) on vrb.id = v.[ReservationBatchId]
			JOIN ClientQuotationProduct AS T1 WITH(NOLOCK) ON T1.Id = OL.ClientQuotationProductId
			JOIN ProductVersion AS T2 WITH(NOLOCK) ON T1.ProductVersionId = T2.Id
			join Product p WITH(NOLOCK) on p.Id=T2.ProductId
			left join Program pro WITH(NOLOCK) on p.ProgramId = pro.Id
			left join VoucherNumberRule vnr WITH(NOLOCK) on p.[VoucherNumberRuleId] = vnr.Id
			join ExpirationPolicy ep WITH(NOLOCK) on ob.ExpirySchemeId = ep.id
			left join SLMSTemplateVersion st WITH(NOLOCK) on ol.SLMSTemplateVersionId = st.Id
			left join OrderSLMSTemplateVersionSet OSTV WITH(NOLOCK) ON  ol.[OrderSLMSTemplateVersionId] = OSTV.[OrderSLMSTemplateVersionId]
			left join SLMSTemplateVersion st1 WITH(NOLOCK) on OSTV.[SLMSTemplateVersionId] = st1.Id AND st1.[LanguageId] IS NOT NULL
			left join SLMSTemplateVersion st2 WITH(NOLOCK) on OSTV.[SLMSTemplateVersionId] = st2.Id AND st2.[LanguageId] = ob.[LanguageId]
			left join [dbo].[EXT_TW_Starbucks] sb WITH(NOLOCK) on v.id = sb.id
			LEFT JOIN ( SELECT  tags.OrderLineId ,
                                    tags.[{SMSGreetings}] AS SMSGreetings ,
                                    tags.[{PRODUCT_NAME}] AS Product_Name
                            FROM    ( SELECT    octv.OrderLineId ,
                                                octv.Value ,
                                                ct.TagName
                                      FROM      dbo.OrderSLMSContentTagValueSet AS octv WITH ( NOLOCK )
                                                LEFT JOIN dbo.ContentTag AS ct
                                                WITH ( NOLOCK ) ON octv.ContentTagId = ct.Id
                                    ) AS pctv PIVOT ( MAX(Value) FOR TagName IN ( [{SMSGreetings}]
                                                              ,[{PRODUCT_NAME}] ) ) AS tags
															  ) AS tt ON ol.Id = tt.OrderLineId
			LEFT JOIN ( SELECT  tags.OrderSLMSTemplateVersionId ,
                        tags.[{SMSGreetings}] AS SMSGreetings ,
                        tags.[{PRODUCT_NAME}] AS Product_Name ,
						tags.LanguageId
						FROM    (SELECT octv.[OrderSLMSTemplateVersionId] ,
										 osttvs.Value ,
										 ct.TagName,
										 st1.LanguageId
								 FROM [dbo].[OrderSLMSTemplateVersionSet] AS octv WITH ( NOLOCK )
								 JOIN SLMSTemplateVersion st1 WITH(NOLOCK) on octv.[SLMSTemplateVersionId] = st1.Id
								 LEFT JOIN [dbo].[OrderSLMSTemplateTagValueSet] AS osttvs WITH(NOLOCK) on octv.[SLMSTemplateTagValueId] = osttvs.[OrderSLMSTemplateTagValueId]
                                 LEFT JOIN dbo.ContentTag AS ct WITH(NOLOCK) ON osttvs.ContentTagId = ct.Id
                        ) AS pctv PIVOT ( MAX(Value) FOR TagName IN ( [{SMSGreetings}]
                                                    ,[{PRODUCT_NAME}] ) ) AS tags
													) AS tx ON ol.OrderSLMSTemplateVersionId = tx.OrderSLMSTemplateVersionId AND tx.LanguageId = ISNULL(ob.[LanguageId],@DefaultLanguageId)
			LEFT JOIN VoucherSequenceNumber vsn WITH(NOLOCK) on vsn.VoucherNumber = v.VoucherNumber
	WHERE o.OrderNumber=@OrderNumber
	ORDER BY p.ProductCode,ob.Mobile,ob.Email,vrb.[CreatedOn] ASC
END

