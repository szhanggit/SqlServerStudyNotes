CREATE PROCEDURE dbo.spGetProductBannerImageInfo
@InputTable VoucherBannerImageInfoType READONLY
AS
BEGIN
	SELECT Identitykey,ml.ExternalURL as BannerImage,IsDynamic,IT.ProductId,HexColor,FontSize,PointX,PointY FROM @InputTable IT INNER JOIN dbo.Product p with(nolock) ON IT.ProductId = p.Id INNER JOIN ProductEmailContentTagValueSet pets with(nolock) on pets.ProductEmailTemplateTagValueId = p.EmailTemplateTagValueId AND pets.ContentTagId = IT.ContentTagId  INNER JOIN MediaLibrary ml with(nolock) on PATINDEX('%[^0-9]%', pets.Value)=0 and ml.Id = pets.Value LEFT JOIN dbo.ProductBannerImageSetting pbis with(nolock) ON pbis.ProductId = IT.ProductId
	WHERE p.EmailTemplateTagValueId IS NOT NULL 
	UNION
	SELECT Identitykey,ml.ExternalURL as BannerImage,IsDynamic,IT.ProductId,HexColor,FontSize,PointX,PointY FROM @InputTable IT INNER JOIN dbo.Product p with(nolock) ON IT.ProductId = p.Id Join ProductEmailTemplateVersionSet petvs with(nolock) on petvs.ProductEmailTemplateVersionId = p.ProductEmailTemplateVersionId
Join ProductEmailContentTagValueSet pets with(nolock) on pets.ProductEmailTemplateTagValueId = petvs.EmailTemplateTagValueId AND pets.ContentTagId = IT.ContentTagId  INNER JOIN MediaLibrary ml with(nolock) on PATINDEX('%[^0-9]%', pets.Value)=0 and ml.Id = pets.Value LEFT JOIN dbo.ProductBannerImageSetting pbis with(nolock) ON pbis.ProductId = IT.ProductId
	WHERE p.EmailTemplateTagValueId IS NULL AND p.ProductEmailTemplateVersionId IS NOT NULL
END