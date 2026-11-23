CREATE PROCEDURE [template].[sp_sel_Tag_list]
	-- Add the parameters for the stored procedure here
	@apply_to_html_template bit,
	@apply_to_text_template bit,
	@TotalCount int = 0 OUTPUT
AS
BEGIN
	IF(@apply_to_html_template = 1)
    BEGIN
			SELECT [tag_id]
		  ,[tag_name]
		  ,[display_name]
		  ,[description]
		  ,[category]
		  ,[type]
		  ,[scope_level]
		  ,[default_value]
		  ,[apply_to_html_template]
		  ,[apply_to_text_template]
		  ,[reflection_type]
	  FROM [template].[tb_t_tag] tt with(nolock) WHERE tt.apply_to_html_template = 1;
    END
    IF(@apply_to_text_template = 1)
    BEGIN
        SELECT [tag_id]
		  ,[tag_name]
		  ,[display_name]
		  ,[description]
		  ,[category]
		  ,[type]
		  ,[scope_level]
		  ,[default_value]
		  ,[apply_to_html_template]
		  ,[apply_to_text_template]
		  ,[reflection_type]
	  FROM [template].[tb_t_tag] tt with(nolock) WHERE tt.apply_to_text_template = 1;
    END
	SET @TotalCount = @@ROWCOUNT
END