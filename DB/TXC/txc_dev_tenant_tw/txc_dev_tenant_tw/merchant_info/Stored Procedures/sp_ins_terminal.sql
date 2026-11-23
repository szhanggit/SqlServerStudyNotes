--Create as terminal

CREATE PROCEDURE [merchant_info].[sp_ins_terminal] 
(
	@shop_id INT,
	@identity_code NVARCHAR(50),
	@external_code NVARCHAR(50),
	@security_key NVARCHAR(48),
	@status INT,
	@created_by NVARCHAR(50),
	@output INT OUTPUT
)
AS
BEGIN
		INSERT INTO merchant_info.tb_t_terminal
		(
			shop_id,
			identity_code,
			external_code,
			security_key,
			status,
			created_on,
			created_by
		)
		VALUES
		(
			@shop_id,
			@identity_code,
			@external_code,
			@security_key,
			@status,
			GETUTCDATE(),
			@created_by
		)
		SET @output = SCOPE_IDENTITY()	
END