CREATE PROCEDURE [merchant_info].[sp_sel_voucher_pin_code]	
AS
BEGIN	
		select [id],
		[description]
		from [merchant_info].[tb_pt_pin_type]with(NOLOCK)		
END