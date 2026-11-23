
CREATE PROCEDURE [spGetBrandIdMediaId]
    @TenantId int
	,@TXCBrandIdMediaIdList TXCBrandIdMediaIdType Readonly
AS
BEGIN
	SET XACT_ABORT ON;
	select s.TXCBrandId
	, brand.BrandId as TX2BrandId
	, s.TXCMediaId
	, media.MediaLibraryId as TX2MediaId
	from @TXCBrandIdMediaIdList s
	left join [TXCBrandMapping] brand with(nolock) on s.TXCBrandId = brand.ExternalId
	left join [TXCMediaLibraryMapping] media with(nolock) on s.TXCMediaId = media.ExternalId
	where brand.TXCTenantId = @TenantId AND media.TXCTenantId = @TenantId

    SET NOCOUNT, XACT_ABORT OFF;
END

