CREATE PROCEDURE [merchant_info].[sp_sel_manage_terminal_list]   
    @identity_code varchar(50),
	@entity VARCHAR(20)  	
AS  
BEGIN  
	IF(UPPER(ltrim(rtrim(@entity))) = 'TERMINAL')  
    BEGIN  
		select top 1 t.id,t.status,0 as TimeOffset, t.security_key as SecurityKey,1 as MaxFailNumber,wk.value WorkKey,wk.created_on WorkKeyCreatedOn,t.work_key_id WorkKeyId
		from merchant_info.tb_t_terminal t WITH(NOLOCK) 
		INNER JOIN merchant_info.tb_s_shop s WITH(NOLOCK) ON s.id=t.shop_id
		INNER JOIN merchant_info.tb_m_merchant m WITH(NOLOCK) ON m.id=s.merchant_id
		LEFT JOIN merchant_info.tb_wk_work_key wk WITH(NOLOCK) ON wk.id=t.work_key_id
		where t.identity_code = @identity_code
    END  
    IF(UPPER(ltrim(rtrim(@entity))) = 'SHOP')  
    BEGIN  
		select top 1 s.id,s.status,0 as TimeOffset, s.security_key as SecurityKey,1 as MaxFailNumber,wk.value WorkKey,wk.created_on WorkKeyCreatedOn,s.work_key_id WorkKeyId
		from merchant_info.tb_s_shop s WITH(NOLOCK) 
		INNER JOIN merchant_info.tb_m_merchant m WITH(NOLOCK) ON m.id=s.merchant_id
		LEFT JOIN merchant_info.tb_wk_work_key wk WITH(NOLOCK) ON wk.id=s.work_key_id
		where s.identity_code = @identity_code
    END  
    IF(UPPER(ltrim(rtrim(@entity))) = 'MERCHANT')  
    BEGIN  
		select top 1 m.id,m.status,0 as TimeOffset, m.security_key as SecurityKey,1 as MaxFailNumber,wk.value WorkKey,wk.created_on WorkKeyCreatedOn,m.work_key_id WorkKeyId
		from merchant_info.tb_m_merchant m WITH(NOLOCK) 
		LEFT JOIN merchant_info.tb_wk_work_key wk WITH(NOLOCK) ON wk.id=m.work_key_id
		where m.identity_code = @identity_code
    END 
END