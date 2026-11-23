CREATE PROCEDURE [template].[sp_sel_template_tags]
AS
begin 
			
select 
	tag_id as TagId,
	tag_name as TagName,
	apply_to_html_template as ApplyToHtmlTemplate,
	apply_to_text_template as ApplyToTextTemplate
from template.tb_t_tag with(nolock)

end