CREATE PROCEDURE [product].[sp_get_brand_by_product_id]
	@product_id int
AS
BEGIN
	SET XACT_ABORT ON;

	select b.id as BrandId, b.brand_name as BrandName, b.media_id as MediaId, b.[Status] as BrandStatus, b.created_on as CreatedOn, b.created_by as CreatedBy 
	from [product].[tb_p_product] p with(nolock)
	left join [merchant_info].[tb_b_brand] b with(nolock) on p.brand_id = b.Id
	where p.product_id = @product_id

    SET NOCOUNT, XACT_ABORT OFF;
END