CREATE PROCEDURE [order].[sp_get_order_beneficiary_info_list_by_order]
	@order_id int
AS
BEGIN
SELECT obi.id as order_beneficiary_info_id,
        obi.order_line_id,
		ol.product_id,
		obi.mobile,
		obi.email,
		obi.voucher_quantity,
		obi.active_date,
		obi.expiry_scheme_id,
		obi.expiry_date,
		obi.client_order_number,
		obi.memo,
		obi.name,
		obi.address,
		obi.post_code,
		obi.ED_order_number,
		obi.member_id,
		obi.language_id,
		obi.status,
		obi.face_value,
		obi.face_value_with_tax,
		obi.sold_price,
		obi.sold_price_with_tax FROM 
		[order].[tb_ob_order_basic] o with(nolock)
		join [order].[tb_ol_order_line] ol with(nolock) on o.id=ol.order_id
		join [order].[tb_obi_order_beneficiary_info] obi with(nolock) on obi.order_line_id = ol.Id
			WHERE o.id = @order_id

END