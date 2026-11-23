CREATE PROCEDURE [product].[sp_sel_external_property]
    @product_id int
AS
BEGIN
	IF(@product_id > 0)
    BEGIN
		select epset.product_external_property_set_id as ProductExternalPropertySetId 
		, epset.product_external_property_id as ProductExternalPropertyId
		, epset.property_name as PropertyName
		, epset.property_value as PropertyValue
		, epset.[description] as [Description]
		from product.tb_p_product p with(nolock)
		inner join [product].tb_p_product_external_property ep with(nolock) on p.external_property_id = ep.product_external_property_id
		inner join [product].tb_p_product_external_property_set epset with(nolock) on epset.product_external_property_id = ep.product_external_property_id
		where p.product_id = @product_id
    END	
END