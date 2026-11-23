CREATE PROCEDURE [order].[sp_get_order_line_list]
	@order_id int
AS
BEGIN
SELECT id,
        [order_id],
		[quotation_product_id],
		[product_id]
		[total_quantity],
		[email_quantity],
		[slms_quantity],
		[email_template_version_id],
		[slms_template_version_id],
		[default_expiration_date],
		[voucher_reservation_code_id],
		[need_short_url],
		[status],
		[expiration_policy_id],
		[message_encoding],
		[published_quantity],
		[ad_hoc_rule_product_id],
		[order_email_template_version_id],
		[order_slms_template_version_id],
		[need_trust_account],
		[cancelled_quantity],
		[child_order_line_id] FROM [order].[tb_ol_order_line] with(nolock) WHERE order_id = @order_id

END