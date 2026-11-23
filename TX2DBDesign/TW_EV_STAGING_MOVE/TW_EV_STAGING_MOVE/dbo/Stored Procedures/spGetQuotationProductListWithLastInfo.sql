
CREATE PROCEDURE [dbo].[spGetQuotationProductListWithLastInfo]
    @QuotationNumber VARCHAR(50) ,
    @PageIndex INT ,
    @PageSize INT ,
    @TotalCount INT OUTPUT
AS
    BEGIN
		DECLARE @CurrentDateTime DATETIME;
		SET @CurrentDateTime = GETDATE()

        SELECT  p.ProductCode ,
                p.ProductName ,
                p.Description AS ProductDescription ,
                ISNULL(CQPSP.SoldPriceWithTax,0) AS SoldPrice ,
                CAST(ISNULL(ISNULL(pppb.FaceValue, ppvb.FaceValue), 0)
                / 100.00 AS NUMERIC(15, 2)) AS FaceValue ,
				case when p.[ProductEmailTemplateVersionId] is not null then pettvs2.ExternalURL
					when p.EmailTemplateVersionId is not null then pettvs.ExternalURL
					else '' end as ImageURL,
				case when p.[ProductEmailTemplateVersionId] is not null then pettvs2.FOOTNOTE
					when p.EmailTemplateVersionId is not null then pettvs.FOOTNOTE					
					else '' end as FootNote,
                d.Name AS ExpiryPolicy ,
                cqp.[ExpirationDate] 
        FROM    dbo.ClientQuotation AS cq
                INNER JOIN dbo.ClientQuotationProduct AS cqp ON cqp.ClientQuotationId = cq.Id
				INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS CQPSP ON cqp.Id = CQPSP.[ClientQuotationProductId]
                INNER JOIN dbo.ProductVersion AS pv WITH ( NOLOCK ) ON pv.Id = cqp.ProductVersionId
                LEFT JOIN dbo.ProductPricingProductBased AS pppb WITH ( NOLOCK ) ON pppb.Id = pv.ProductPricingProductBasedId
                LEFT JOIN dbo.ProductPricingValueBased AS ppvb WITH ( NOLOCK ) ON ppvb.Id = pv.ProductPricingValueBasedId
                INNER JOIN dbo.Product AS p ON p.Id = pv.ProductId
                INNER JOIN dbo.ExpirationPolicy AS ep WITH ( NOLOCK ) ON cqp.ExpirySchemeId = ep.Id
                INNER JOIN dbo.Dictionary AS d WITH ( NOLOCK ) ON ep.DisplayNameId = d.Id
                LEFT JOIN ( SELECT  tags.ProductEmailTemplateTagValueId ,
                                    [{FOOTNOTE}] AS FOOTNOTE ,
                                    ml.ExternalURL
                            FROM    ( SELECT    pect.ProductEmailTemplateTagValueId ,
                                                pect.Value ,
                                                TagName
                                      FROM      dbo.ProductEmailContentTagValueSet
                                                AS pect WITH ( NOLOCK )
                                                RIGHT JOIN dbo.ContentTag AS ct
                                                WITH ( NOLOCK ) ON pect.ContentTagId = ct.Id
                                    ) AS pctv PIVOT ( MAX(Value) FOR TagName IN ( [{FOOTNOTE}],
                                                              [{BANNER_IMAGE}] ) ) AS tags
                                    LEFT JOIN dbo.MediaLibrary AS ml WITH ( NOLOCK ) ON tags.[{BANNER_IMAGE}] = ml.Id
                          ) AS pettvs ON p.EmailTemplateTagValueId = pettvs.ProductEmailTemplateTagValueId
				LEFT JOIN [dbo].[ProductEmailTemplateVersionSet] AS T2 WITH ( NOLOCK ) ON p.[ProductEmailTemplateVersionId] = T2.[ProductEmailTemplateVersionId]
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
                --AND sfd.Name = N'System Process Fee'
				AND CQPSP.ValidityFrom <= @CurrentDateTime 
				AND CQPSP.ValidityEnd >= @CurrentDateTime
				AND CQPSP.[Status] = 2 
        ORDER BY p.ProductCode
                OFFSET ( @PageIndex - 1 ) * @PageSize ROWS FETCH NEXT @PageSize
                ROWS ONLY

        SELECT  @TotalCount = COUNT(*)
        FROM    dbo.ClientQuotation AS cq
                INNER JOIN dbo.ClientQuotationProduct AS cqp ON cqp.ClientQuotationId = cq.Id
        WHERE   cq.QuotationNumber = @QuotationNumber

    END
