CREATE PROCEDURE [product].[sp_sel_product_template]

	-- Add the parameters for the stored procedure here
	@ProductId int,
	@TemplateType int
AS
begin 


		select
			t.template_id as TemplateId,
			t.template_name as TemplateName,
			tv.template_version_id as TemplateVersionId
		from product.tb_p_product_template_version ptv with(nolock) 
		join product.tb_p_product_template_set ts with(nolock) on ts.product_template_version_id = ptv.product_template_version_id
		join product.tb_p_product p with(nolock) on p.template_id = ts.product_template_id
		join template.tb_t_template_version tv with(nolock) on ptv.template_version_id = tv.template_version_id
		join template.tb_t_template t with(nolock) on tv.template_id = t.template_id
		where 
			p.product_id = @ProductId
			and ts.template_type = @TemplateType
end