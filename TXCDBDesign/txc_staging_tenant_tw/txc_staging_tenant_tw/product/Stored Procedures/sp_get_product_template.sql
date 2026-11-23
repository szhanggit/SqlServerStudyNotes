CREATE PROCEDURE [product].[sp_get_product_template]
	@product_template_id INT
AS
BEGIN 
	SELECT  pts.template_type TemplateType,
			pts.template_sub_type TemplateSubType,
			tv.template_version_id TemplateVersionId,
			t.template_id TemplateId,
			t.template_name TemplateName,
			ptv.product_template_version_id ProductTemplateVersionId,
			pttvs.tag_id ContentTagId,
			pttvs.value [Value],
			pttvs.text_value TextValue
		FROM product.tb_p_product_template_set pts WITH(NOLOCK)
		JOIN product.tb_p_product_template_version ptv WITH(NOLOCK) ON ptv.product_template_version_id = pts.product_template_version_id
		LEFT JOIN product.tb_p_product_template_tag_value_set pttvs WITH(NOLOCK) ON pttvs.product_template_tag_value_id = ptv.product_template_tag_value_id
		JOIN template.tb_t_template_version tv WITH(NOLOCK) ON tv.template_version_id = ptv.template_version_id
		JOIN  template.tb_t_template t WITH(NOLOCK) ON t.template_id = tv.template_id
	WHERE pts.product_template_id = @product_template_id;
END