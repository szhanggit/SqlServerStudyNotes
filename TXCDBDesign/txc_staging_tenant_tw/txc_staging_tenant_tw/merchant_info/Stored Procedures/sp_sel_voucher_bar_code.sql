CREATE PROCEDURE [merchant_info].[sp_sel_voucher_bar_code]	
AS
BEGIN	
		select [id],
		[description]
		from [merchant_info].[tb_bt_barcode_type] with(NOLOCK)		
END