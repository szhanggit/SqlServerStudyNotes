CREATE PROCEDURE [merchant_info].[sp_sel_shop_list] 
    @row_count int = 20,  
	@page_offset int = 0,  
	@search_key_word NVARCHAR(100),  
	@merchant_id INT = 0,  
	@total_count int = 0 OUTPUT  
AS  
BEGIN  
set @search_key_word=  isnull(@search_key_word,'')
if(@row_count=0)
begin
set @row_count=20
END
        CREATE TABLE #Tmp   
        (  
            ID INT NOT NULL  
        );  
        BEGIN TRY  
			INSERT INTO #Tmp SElECT id FROM  
			(  
			SElECT s.id FROM [merchant_info].[tb_s_shop] AS s with(nolock)   
			where (s.merchant_id=@merchant_id or @merchant_id=0) and s.name LIKE '%'+@search_key_word+'%' 
			Union  
			SElECT s.id FROM [merchant_info].[tb_s_shop] AS s with(nolock)   
			where (s.merchant_id=@merchant_id or @merchant_id=0) and s.identity_code LIKE '%'+@search_key_word+'%'  
			Union  
			SElECT s.id FROM [merchant_info].[tb_s_shop] AS s with(nolock)   
			where (s.merchant_id=@merchant_id or @merchant_id=0) and s.external_code LIKE '%'+@search_key_word+'%'
			UNION
			SElECT s.id FROM [merchant_info].[tb_s_shop] AS s with(nolock) 
			INNER JOIN [general].[tb_a_address] a with(nolock) ON s.address_id=a.address_id where  (s.merchant_id=@merchant_id or @merchant_id=0) and a.detail_address_line LIKE '%'+@search_key_word+'%'
			) SH  
  
			SELECT s.id AS ShopId,  
				 s.merchant_id AS MerchantId,  
				 s.address_id AS AddressId,  
				 s.identity_code AS IdentityCode,  
				 s.name AS ShopName,  
				 s.external_code AS ExternalCode,  
				 s.security_key AS SecurityKey,  
				 s.status AS ShopStatus,  
				 s.contact_name AS ContactName,
				 s.contact_phone AS ContactPhone,
				 s.subsidiary_uen AS SubsidiaryUen,
				 s.subsidiary_name AS SubsidiaryName,
				 s.contact_name2 AS ContactName2,
				 s.contact_phone2 AS ContactPhone2,
				 a.city_id AS CityId,  
				 a.country_id AS CountryId,  
				 a.detail_address_line AS DetailAddressLine,  
				 a.district AS District,  
				 a.postcode AS Postcode,  
				 a.state_province_id AS StateOrProvinceId,  
				 a.status AS AddressStatus,  
				 a.latitude AS Latitude,  
				 a.longitude AS Longitude,
				 wk.id AS WorkKeyId,
				 wk.value AS WorkKey,
				 wk.expired_on AS WorkKeyExpireTime,
				 wk.created_on AS WorkKeyCreatedTime
			FROM #Tmp t with(nolock)   
			INNER JOIN  [merchant_info].[tb_s_shop] AS s with(nolock) on t.Id = s.id  
			INNER JOIN [general].[tb_a_address] a with(nolock) ON s.address_id=a.address_id 
			LEFT JOIN [merchant_info].[tb_wk_work_key] AS wk WITH(NOLOCK) ON wk.id=s.work_key_id
			Order BY s.id desc
				OFFSET @page_offset ROWS  
			FETCH NEXT @row_count ROWS ONLY 
			
			SET @total_count = (select isnull(count(1),0) from #Tmp)  
		END TRY

		BEGIN CATCH 
			SET @total_count = 0
		END CATCH       
          
        DROP TABLE #Tmp      
END