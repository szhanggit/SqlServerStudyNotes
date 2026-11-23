CREATE PROCEDURE [dbo].[spGetQuotationProductLastDetailInfo]
    @QuotationNumber VARCHAR(50) ,
    @ProductCode VARCHAR(50)
AS
    BEGIN
		DECLARE @CurrentDateTime DATETIME;
		SET @CurrentDateTime = GETDATE()

        SELECT  p.ProductCode ,
                p.ProductName ,
                p.Description AS ProductDescription ,
                ISNULL((case p.ProductType when 1 then cqpsp.SoldPriceWithTax when 2 then cqpsp.ValueBasedSoldPriceWithTax end),0) AS SoldPrice ,
                CAST(ISNULL(ISNULL(pppb.FaceValue, ppvb.FaceValue), 0)
                / 100.00 AS NUMERIC(15, 2)) AS FaceValue ,
                cqpsftt.SoldPriceWithTax AS FeeWithTax ,
				sfd.Name AS ServiceFeeName,
				case when p.[ProductEmailTemplateVersionId] is not null then pettvs2.ExternalURL
					when p.EmailTemplateVersionId is not null then pettvs.ExternalURL
					else '' end as ImageURL,
				case when p.[ProductEmailTemplateVersionId] is not null then pettvs2.FOOTNOTE
					when p.EmailTemplateVersionId is not null then pettvs.FOOTNOTE
					else '' end as FootNote,
                d.Name AS ExpiryPolicy ,
				case when p.[ProductEmailTemplateVersionId] is not null then T3.Content
					when p.EmailTemplateVersionId is not null then etv.Content
					else '' end as EmailTemplate,
				case when P.[ProductSLMSTemplateVersionId] is not null then t5.Content1
					when p.SLMSTemplateVersionId is not null then sms.Content1
					else '' end as SMSTemplate,               
				case WHEN d.Name = 'FixEndOfDay' and p.ExpirationDate is not null THEN p.ExpirationDate ELSE cqp.[ExpirationDate] END as ExpirationDate,
				case when p.[ProductEmailTemplateVersionId] is not null then pettvs2.STOREURL
					when p.[EmailTemplateVersionId] is not null then pettvs.STOREURL
					else '' end as StoreURL,
                cq.BusinessTypeId ,
                cqp.ProductVersionId
        FROM    dbo.ClientQuotation AS cq
                INNER JOIN dbo.ClientQuotationProduct AS cqp ON cqp.ClientQuotationId = cq.Id
				INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS CQPSP ON cqp.Id = CQPSP.ClientQuotationProductId
                LEFT JOIN dbo.ClientQuotationProductServiceFeeTriggerTime AS cqpsftt
                WITH ( NOLOCK ) ON cqpsftt.ClientQuotationProductId = cqp.Id
                LEFT JOIN dbo.ServiceFeeTriggerTime AS sftt WITH ( NOLOCK ) ON sftt.Id = cqpsftt.ServiceFeeTriggerTimeId
                                                              AND sftt.TranType = 401
                LEFT JOIN dbo.ServiceFee AS sf WITH ( NOLOCK ) ON sf.Id = sftt.ServiceFeeId
                LEFT JOIN dbo.Dictionary AS sfd WITH ( NOLOCK ) ON sfd.Id = sf.ServiceFeeNameId
                INNER JOIN dbo.ProductVersion AS pv WITH ( NOLOCK ) ON pv.Id = cqp.ProductVersionId
                LEFT JOIN dbo.ProductPricingProductBased AS pppb WITH ( NOLOCK ) ON pppb.Id = pv.ProductPricingProductBasedId
                LEFT JOIN dbo.ProductPricingValueBased AS ppvb WITH ( NOLOCK ) ON ppvb.Id = pv.ProductPricingValueBasedId
                INNER JOIN dbo.Product AS p ON p.Id = pv.ProductId
                INNER JOIN dbo.ExpirationPolicy AS ep WITH ( NOLOCK ) ON cqp.ExpirySchemeId = ep.Id
                INNER JOIN dbo.Dictionary AS d WITH ( NOLOCK ) ON ep.DisplayNameId = d.Id
                LEFT JOIN ( SELECT  tags.ProductEmailTemplateTagValueId ,
                                    tags.[{FOOTNOTE}] AS FOOTNOTE ,
                                    tags.[{STORE_URL}] AS STOREURL ,
                                    ml.ExternalURL
                            FROM    ( SELECT    pect.ProductEmailTemplateTagValueId ,
                                                pect.Value ,
                                                TagName
                                      FROM      dbo.ProductEmailContentTagValueSet
                                                AS pect WITH ( NOLOCK )
                                                RIGHT JOIN dbo.ContentTag AS ct
                                                WITH ( NOLOCK ) ON pect.ContentTagId = ct.Id
                                    ) AS pctv PIVOT ( MAX(Value) FOR TagName IN ( [{FOOTNOTE}],
                                                              [{BANNER_IMAGE}],
                                                              [{STORE_URL}] ) ) AS tags
                                    LEFT JOIN dbo.MediaLibrary AS ml WITH ( NOLOCK ) ON tags.[{BANNER_IMAGE}] = ml.Id
                          ) AS pettvs ON p.EmailTemplateTagValueId = pettvs.ProductEmailTemplateTagValueId
                LEFT JOIN dbo.EmailTemplateVersion AS etv WITH ( NOLOCK ) ON p.EmailTemplateVersionId = etv.Id
                LEFT JOIN dbo.SLMSTemplateVersion AS sms WITH ( NOLOCK ) ON p.SLMSTemplateVersionId = sms.Id
				LEFT JOIN [dbo].[ProductEmailTemplateVersionSet] AS T2 WITH ( NOLOCK ) ON p.[ProductEmailTemplateVersionId] = T2.[ProductEmailTemplateVersionId]
				LEFT JOIN [dbo].[EmailTemplateVersion] AS T3 WITH ( NOLOCK ) ON T2.[EmailTemplateVersionId] = T3.[Id]
				LEFT JOIN [dbo].[ProductSLMSTemplateVersionSet] AS T4 WITH ( NOLOCK ) ON P.[ProductSLMSTemplateVersionId] = T4.[ProductSLMSTemplateVersionId]
				LEFT JOIN [dbo].[SLMSTemplateVersion] AS T5 WITH ( NOLOCK ) ON t4.[SLMSTemplateVersionId] = T5.Id				
				LEFT JOIN ( SELECT  tags.ProductEmailTemplateTagValueId ,
                                    tags.[{FOOTNOTE}] AS FOOTNOTE ,
                                    tags.[{STORE_URL}] AS STOREURL ,
                                    ml.ExternalURL
                            FROM    ( SELECT    pect.ProductEmailTemplateTagValueId ,
                                                pect.Value ,
                                                TagName
                                      FROM      dbo.ProductEmailContentTagValueSet AS pect WITH ( NOLOCK )
                                                RIGHT JOIN dbo.ContentTag AS ct
                                                WITH ( NOLOCK ) ON pect.ContentTagId = ct.Id
                                    ) AS pctv PIVOT ( MAX(Value) FOR TagName IN ( [{FOOTNOTE}],
                                                              [{BANNER_IMAGE}],
                                                              [{STORE_URL}] ) ) AS tags
                                    LEFT JOIN dbo.MediaLibrary AS ml WITH ( NOLOCK ) ON tags.[{BANNER_IMAGE}] = ml.Id
                          ) AS pettvs2 ON T2.[EmailTemplateTagValueId] = pettvs2.ProductEmailTemplateTagValueId
        WHERE   cq.QuotationNumber = @QuotationNumber
                AND p.ProductCode = @ProductCode
				AND CQPSP.ValidityFrom <= @CurrentDateTime
				AND CQPSP.ValidityEnd >= @CurrentDateTime
				AND CQPSP.Status = 2
				AND ((cqpsftt.ValidityFrom <= @CurrentDateTime AND cqpsftt.ValidityEnd >= @CurrentDateTime AND cqpsftt.Status = 2) OR cqpsftt.Id IS NULL)
    END
	
		
