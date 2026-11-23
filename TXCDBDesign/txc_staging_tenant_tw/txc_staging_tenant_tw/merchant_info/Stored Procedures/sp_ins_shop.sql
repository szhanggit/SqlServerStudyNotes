
CREATE PROCEDURE [merchant_info].[sp_ins_shop]
(
    @identity_code NVARCHAR(50),
	@name NVARCHAR(100),
	@merchant_id INT,
	@address_id INT,
	@external_code NVARCHAR(50),
	@contact_name NVARCHAR(50),
	@contact_phone NVARCHAR(50),
	@security_key NVARCHAR(48),
	@status INT,
	@subsidiary_uen NVARCHAR(30),
	@subsidiary_name NVARCHAR(100),
	@last_modifier NVARCHAR(50),
	@contact_name2 NVARCHAR(50),
	@contact_phone2 NVARCHAR(50),
	@output INT OUTPUT
)
AS
BEGIN    
		INSERT INTO merchant_info.tb_s_shop 
		(
			identity_code,
			[name],
			merchant_id,
			address_id,
			external_code,
			contact_name,
			contact_phone,
			security_key,
			[status],
			subsidiary_uen,
			subsidiary_name,
			created_on,
			last_modified_on,
			last_modifier,
			contact_name2,
			contact_phone2
		) 
		VALUES
		(
			@identity_code,
			@name,
			@merchant_id,
			@address_id,
			@external_code,
			@contact_name,
			@contact_phone,
			@security_key,
			@status,
			@subsidiary_uen,
			@subsidiary_name,
			GETDATE(),
			GETDATE(),
			@last_modifier,
			@contact_name2,
			@contact_phone2
		)	
		SET @output = SCOPE_IDENTITY()

		select SCOPE_IDENTITY() as Id;


END