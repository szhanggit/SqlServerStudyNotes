CREATE PROCEDURE [merchant_info].[sp_sel_shop_list_by_id]  
	@shop_id INT = 0
	
AS  
BEGIN  

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
	   FROM [merchant_info].[tb_s_shop] AS s with(nolock)   
	   INNER JOIN [general].[tb_a_address] a with(nolock) ON s.address_id=a.address_id  
	   LEFT JOIN [merchant_info].[tb_wk_work_key] AS wk WITH(NOLOCK) ON wk.id=s.work_key_id
	   where s.id = @shop_id;    
  
END