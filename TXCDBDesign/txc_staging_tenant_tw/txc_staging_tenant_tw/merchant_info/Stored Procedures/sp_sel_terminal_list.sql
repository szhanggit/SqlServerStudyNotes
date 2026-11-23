CREATE PROCEDURE [merchant_info].[sp_sel_terminal_list] 
    @row_count int = 20,  
	@page_offset int = 0,  
	@search_key_word NVARCHAR(100)='',  
	@shop_id INT = 0,  
	@total_count int = 0 OUTPUT  
AS  
BEGIN  
	set @search_key_word=isnull(@search_key_word,'')
	SELECT t.id AS TerminalId,  
	 t.shop_id AS ShopId, 		  
	 t.identity_code AS IdentityCode, 
	 t.external_code AS ExternalCode,  
	 t.security_key AS SecurityKey,  
	 t.status AS TerminalStatus,
	 wk.id AS WorkKeyId,
	 wk.value AS WorkKey,
	 wk.expired_on AS WorkKeyExpireTime,
	 wk.created_on AS WorkKeyCreatedTime
	 FROM [merchant_info].[tb_t_terminal] AS t with(nolock)  
	 left JOIN [merchant_info].[tb_wk_work_key] AS wk WITH(NOLOCK) ON WK.id=t.work_key_id
	 where (t.shop_id = @shop_id or @shop_id=0) and (t.identity_code LIKE '%'+@search_key_word+'%' or @search_key_word='')
	 order by t.id
		OFFSET @page_offset ROWS  
	FETCH NEXT @row_count ROWS ONLY 

   SET @total_count = @@ROWCOUNT;  
    
END