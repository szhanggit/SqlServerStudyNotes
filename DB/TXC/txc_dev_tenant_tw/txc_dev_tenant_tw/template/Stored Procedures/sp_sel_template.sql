CREATE PROCEDURE [template].[sp_sel_template]

	-- Add the parameters for the stored procedure here
	@TemplateVersionId int
AS
begin 
			
	select
		t.template_id as TemplateId,
		t.template_name as TemplateName,
		t.[type] as TemplateType,
		v.[version] as [Version],
		v.language_id as LanguageId,
		v.[description] as [Description],
		v.subject1 as Subject1,
		v.content1 as Content1,
		v.subject2 as Subject2,
		v.content2 as Content2,
		v.subject3 as Subject3,
		v.content3 as Content3
	from template.tb_t_template_version v with(nolock) 
	join template.tb_t_template t with(nolock) on v.template_id = t.template_id
	where template_version_id = @TemplateVersionId

end