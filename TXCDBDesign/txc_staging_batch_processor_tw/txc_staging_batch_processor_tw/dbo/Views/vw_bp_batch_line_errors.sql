
    create VIEW [vw_bp_batch_line_errors] AS
    SELECT
        'General' as [domain_type],
        batch_line_error_id as [domain_error_id],
        batch_line_error_master_id,
        batch_line_id
    FROM
        tb_bp_batch_line_error
    UNION
    ALL
    SELECT
        'VoucherOperation' as [domain_type],
        batch_line_voucher_operations_error_id as [domain_error_id],
        batch_line_error_master_id,
        batch_line_id
    FROM
        tb_bp_batch_line_voucher_operations_error voe
        INNER JOIN [tb_bp_batch_line_voucher_operations_detail] vod ON voe.batch_line_voucher_operations_id = vod.batch_line_voucher_operations_id
    UNION
    ALL
    SELECT
        'Order' as [domain_type],
        batch_line_order_error_id as [domain_error_id],
        batch_line_error_master_id,
        batch_line_id
    FROM
        tb_bp_batch_line_order_error oe
        INNER JOIN [tb_bp_batch_line_order_detail] od ON oe.batch_line_order_id = od.batch_order_detail_id
    UNION
    ALL
    SELECT
        'Inventory' as [domain_type],
        batch_line_inventory_error_id as [domain_error_id],
        batch_line_error_master_id,
        batch_line_id
    FROM
        tb_bp_batch_line_inventory_error ie
        INNER JOIN [tb_bp_batch_line_inventory_detail] id ON ie.batch_inventory_detail_id = id.batch_line_inventory_detail_id
