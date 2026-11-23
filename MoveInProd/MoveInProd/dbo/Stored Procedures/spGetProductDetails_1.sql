
create procedure spGetProductDetails @QuotationNumber VARCHAR(50), @ProductCode VARCHAR(50)
as
BEGIN
	set nocount ON;

    SELECT  p.ProductCode ProductInternalCode ,
			p.ExternalProductCode ProductExternalCode,
            p.ProductName ,
            p.[Description] ProductDescription ,
			case when p.[ProductEmailTemplateVersionId] is not null then ml2.ExternalURL
				when p.EmailTemplateVersionId is not null then ml.ExternalURL
				else '' end as ImageURL,
			p.Note,
			case when p.[ProductEmailTemplateVersionId] is not null then pettvs2.STOREURL
				when p.[EmailTemplateVersionId] is not null then pettvs.STOREURL
				else '' end as StoreURL,
            d.[Name] AS ExpiryPolicy ,
            cqp.[ExpirationDate] ExpiryDate			
			FROM    dbo.ClientQuotation AS cq
            JOIN	dbo.ClientQuotationProduct AS cqp ON cqp.ClientQuotationId = cq.Id
            JOIN	dbo.ProductVersion AS pv WITH (NOLOCK) ON pv.Id = cqp.ProductVersionId
            JOIN	dbo.Product AS p ON p.Id = pv.ProductId
            JOIN	dbo.ExpirationPolicy AS ep WITH ( NOLOCK ) ON cqp.ExpirySchemeId = ep.Id
            JOIN	dbo.Dictionary AS d WITH ( NOLOCK ) ON ep.DisplayNameId = d.Id
            LEFT JOIN ( SELECT  tags.ProductEmailTemplateTagValueId ,
                                tags.[{FOOTNOTE}] AS FOOTNOTE ,
                                tags.[{STORE_URL}] AS STOREURL ,                                
                                tags.[{BANNER_IMAGE}] AS BANNERIMAGE
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
                        ) AS pettvs ON p.EmailTemplateTagValueId = pettvs.ProductEmailTemplateTagValueId
			LEFT JOIN dbo.MediaLibrary AS ml WITH ( NOLOCK ) ON pettvs.BANNERIMAGE = ml.Id
			LEFT JOIN [dbo].[ProductEmailTemplateVersionSet] AS T2 WITH ( NOLOCK ) ON p.[ProductEmailTemplateVersionId] = T2.[ProductEmailTemplateVersionId]
			LEFT JOIN [dbo].[EmailTemplateVersion] AS T3 WITH ( NOLOCK ) ON T2.[EmailTemplateVersionId] = T3.[Id]			
			LEFT JOIN ( SELECT  tags.ProductEmailTemplateTagValueId ,
                                tags.[{FOOTNOTE}] AS FOOTNOTE ,
                                tags.[{STORE_URL}] AS STOREURL ,
                                tags.[{BANNER_IMAGE}] AS BANNERIMAGE
                        FROM    ( SELECT    pect.ProductEmailTemplateTagValueId ,
                                            pect.Value ,
                                            TagName
                                    FROM      dbo.ProductEmailContentTagValueSet AS pect WITH ( NOLOCK )
                                            RIGHT JOIN dbo.ContentTag AS ct
                                            WITH ( NOLOCK ) ON pect.ContentTagId = ct.Id
                                ) AS pctv PIVOT ( MAX(Value) FOR TagName IN ( [{FOOTNOTE}],
                                                            [{BANNER_IMAGE}],
                                                            [{STORE_URL}] ) ) AS tags
                        ) AS pettvs2 ON T2.[EmailTemplateTagValueId] = pettvs2.ProductEmailTemplateTagValueId
			LEFT JOIN dbo.MediaLibrary AS ml2 WITH ( NOLOCK ) ON pettvs2.BANNERIMAGE = ml2.Id
    WHERE   cq.QuotationNumber = @QuotationNumber AND p.ProductCode = @ProductCode
end
