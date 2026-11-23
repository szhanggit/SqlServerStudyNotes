CREATE PROCEDURE [merchant_info].[sp_upd_workkey] 
(
	@work_key_id int,
    @value NVARCHAR(50),	
	@created_on datetime,
	@expired_on datetime
)
AS
BEGIN    
		UPDATE merchant_info.tb_wk_work_key SET [Value] = @value, created_on = @created_on, expired_on = @expired_on WHERE Id = @work_key_id
		
END