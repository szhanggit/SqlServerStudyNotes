CREATE PROCEDURE [merchant_info].[sp_sel_voucher_number_algorithm]	
AS
BEGIN	
		select [id],
		[name_id] 'NameId'
from [merchant_info].[tb_vna_voucher_number_algorithm] with(NOLOCK)		
END