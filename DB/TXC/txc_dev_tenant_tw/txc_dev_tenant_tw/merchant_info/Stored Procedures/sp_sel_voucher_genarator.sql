CREATE PROCEDURE [merchant_info].[sp_sel_voucher_genarator]	
AS
BEGIN	
		select [id],
		[description]
		from [merchant_info].[tb_vg_voucher_generator] with(NOLOCK)		
END