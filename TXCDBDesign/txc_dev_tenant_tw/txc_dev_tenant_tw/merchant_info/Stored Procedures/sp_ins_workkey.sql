-- Insert as workkey
CREATE PROCEDURE [merchant_info].[sp_ins_workkey] 
(
    @value NVARCHAR(50),
	@entity NVARCHAR(20),
	@merchant_id INT,
	@shop_id INT,
	@terminal_id NVARCHAR(50),
	@expired_on datetime,
	@output INT OUTPUT
)
AS
BEGIN    
		INSERT INTO merchant_info.tb_wk_work_key 
		(
			[value],
			entity,
			created_on,
			expired_on
		) 
		VALUES
		(
			@value,
			@entity,
			GETUTCDATE(),
			@expired_on
		)	
		SET @output = SCOPE_IDENTITY()

		IF @merchant_id>0
		BEGIN
			UPDATE tb_m_merchant SET work_key_id=@output WHERE id=@merchant_id
		END
		IF @shop_id>1
		BEGIN
			UPDATE tb_s_shop SET work_key_id=@output WHERE id=@shop_id
		END
		IF @terminal_id>1
		BEGIN
			UPDATE tb_t_terminal SET work_key_id=@output WHERE id=@terminal_id
		END
END