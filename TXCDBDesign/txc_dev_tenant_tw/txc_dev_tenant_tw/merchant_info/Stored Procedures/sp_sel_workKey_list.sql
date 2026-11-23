CREATE PROCEDURE [merchant_info].[sp_sel_workKey_list]
    @work_key_id int = 0,  
	@work_key NVARCHAR(100)=''
	
AS  
BEGIN  
	SELECT top 2 *
	 FROM [merchant_info].[tb_wk_work_key] with(nolock)   	   
	 where (id = @work_key_id or @work_key_id=0) and ([value]=@work_key or @work_key='')
	 
END