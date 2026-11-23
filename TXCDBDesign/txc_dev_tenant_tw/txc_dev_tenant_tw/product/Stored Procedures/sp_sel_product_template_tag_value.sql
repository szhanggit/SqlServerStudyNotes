CREATE PROCEDURE [product].[sp_sel_product_template_tag_value]

	-- Add the parameters for the stored procedure here
	@ProductId int,
	@TemplateType int
AS
begin 

		select 
			t.tag_id as TagId,
			t.tag_name as TagName,
			tvs.[value] as [Value],
			tvs.[text_value] as [TextValue]
		from product.tb_p_product_template_tag_value_set tvs with(nolock)
		join template.tb_t_tag t with(nolock) on tvs.tag_id = t.tag_id
		join product.tb_p_product_template_version tv with(nolock) on tv.product_template_tag_value_id = tvs.product_template_tag_value_id
		join product.tb_p_product_template_set ts with(nolock) on ts.product_template_version_id = tv.product_template_version_id
		join product.tb_p_product p with(nolock) on p.template_id = ts.product_template_id
		where 
			p.product_id = @ProductId
			and ts.template_type = @TemplateType
end