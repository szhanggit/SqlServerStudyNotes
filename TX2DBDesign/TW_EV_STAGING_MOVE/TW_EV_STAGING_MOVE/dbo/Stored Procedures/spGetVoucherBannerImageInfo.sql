CREATE PROCEDURE dbo.spGetVoucherBannerImageInfo
@InputTable VoucherBannerImageInfoType READONLY
AS
BEGIN
	SELECT Identitykey,ml.ExternalURL as BannerImage,IsDynamic,IT.ProductId,HexColor,FontSize,PointX,PointY FROM @InputTable IT INNER JOIN dbo.OrderEmailContentTagValueSet vSet WITH(NOLOCK) ON vSet.ContentTagId =IT.ContentTagId AND vSet.OrderLineId = IT.OrderLineId INNER JOIN MediaLibrary ml with(nolock) on PATINDEX('%[^0-9]%', vSet.[value])=0 and ml.Id = vSet.[value] LEFT JOIN dbo.ProductBannerImageSetting pbis with(nolock) ON pbis.ProductId = IT.ProductId
	WHERE IT.EmailTemplateVersionId > 0 
	UNION
	SELECT Identitykey,ml.ExternalURL as BannerImage,IsDynamic,IT.ProductId,HexColor,FontSize,PointX,PointY FROM @InputTable IT INNER JOIN dbo.OrderEmailTemplateVersionSet tSet WITH(NOLOCK) ON IT.OrderEmailTemplateVersionId = tSet.OrderEmailTemplateVersionId INNER JOIN dbo.OrderEmailTemplateTagValueSet vSet WITH(NOLOCK) ON vset.OrderEmailTemplateTagValueId = tSet.EmailTemplateTagValueId AND vSet.ContentTagId =IT.ContentTagId INNER JOIN MediaLibrary ml with(nolock) on PATINDEX('%[^0-9]%', vSet.[value])=0 and ml.Id = vSet.[value] LEFT JOIN dbo.ProductBannerImageSetting pbis with(nolock) ON pbis.ProductId = IT.ProductId INNER JOIN dbo.EmailTemplateVersion ev WITH(NOLOCK) ON ev.Id = tSet.EmailTemplateVersionId AND ev.LanguageId = IT.languageId 
	WHERE IT.OrderEmailTemplateVersionId > 0 AND IT.LanguageId > 0
	UNION
	SELECT Identitykey,ml.ExternalURL as BannerImage,IsDynamic,IT.ProductId,HexColor,FontSize,PointX,PointY FROM @InputTable IT INNER JOIN dbo.OrderEmailTemplateVersionSet tSet WITH(NOLOCK) ON IT.OrderEmailTemplateVersionId = tSet.OrderEmailTemplateVersionId INNER JOIN dbo.OrderEmailTemplateTagValueSet vSet WITH(NOLOCK) ON vset.OrderEmailTemplateTagValueId = tSet.EmailTemplateTagValueId AND vSet.ContentTagId =IT.ContentTagId INNER JOIN MediaLibrary ml with(nolock) on PATINDEX('%[^0-9]%', vSet.[value])=0 and ml.Id = vSet.[value] LEFT JOIN dbo.ProductBannerImageSetting pbis with(nolock) ON pbis.ProductId = IT.ProductId INNER JOIN dbo.EmailTemplateVersion ev WITH(NOLOCK) ON ev.Id = tSet.EmailTemplateVersionId 
	  INNER	JOIN dbo.EmailTemplate e WITH(NOLOCK) ON e.Id = ev.TemplateId AND e.DefaultLanguageId = ev.LanguageId
	WHERE IT.OrderEmailTemplateVersionId > 0 AND IT.LanguageId = 0
END