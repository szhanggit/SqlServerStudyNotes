CREATE PROCEDURE [order].[sp_sel_count_benefiaciary_info]
	@OrderId INT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

	SELECT 
		o.id "OrderId",
		ol.id "OrderLineId",
		obi.id "OrderBeneficiaryInfoId",
		obi.voucher_quantity "VoucherQuantity"
	FROM [order].[tb_ob_order_basic] o WITH (NOLOCK)
	JOIN [order].[tb_ol_order_line] ol WITH (NOLOCK) ON o.id = ol.order_id
	JOIN [order].[tb_obi_order_beneficiary_info] obi WITH (NOLOCK) ON ol.id = obi.order_line_id
	WHERE o.id = @OrderId


    END TRY
    BEGIN CATCH 
       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

		THROW
    END CATCH;
	SET NOCOUNT, XACT_ABORT OFF;
END