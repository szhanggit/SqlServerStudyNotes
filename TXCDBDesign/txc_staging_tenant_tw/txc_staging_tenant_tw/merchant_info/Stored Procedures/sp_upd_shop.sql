CREATE PROCEDURE [merchant_info].[sp_upd_shop]
(
	@shop_id INT,
	@name NVARCHAR(100),	
	@external_code NVARCHAR(50),
	@contact_name NVARCHAR(50),
	@contact_phone NVARCHAR(50),
	@security_key NVARCHAR(48),
	@status INT,
	@subsidiary_uen NVARCHAR(30),
	@subsidiary_name NVARCHAR(100),
	@contact_name2 NVARCHAR(50),
	@contact_phone2 NVARCHAR(50),
	@last_modifier NVARCHAR(50)
)
AS
BEGIN
		UPDATE merchant_info.tb_s_shop 
		SET
			[name] = @name,
			external_code = @external_code,			
			security_key = @security_key,
			contact_name=@contact_name,
			contact_phone=@contact_phone,
			[status] = @status,
			subsidiary_uen=@subsidiary_uen,
			subsidiary_name=@subsidiary_name,
			last_modifier=@last_modifier,
			last_modified_on=GETUTCDATE(),
			contact_name2=@contact_name2,
			contact_phone2=@contact_phone2
		WHERE id = @shop_id    
END