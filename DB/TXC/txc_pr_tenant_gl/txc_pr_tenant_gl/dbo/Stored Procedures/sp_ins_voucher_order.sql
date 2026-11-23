CREATE PROCEDURE [dbo].[sp_ins_voucher_order]
	@OrderId INT
AS
BEGIN
    

    IF(EXISTS (SELECT TOP 1 * FROM [dbo].tb_vo_voucher_order WHERE order_id = @OrderId))
		BEGIN
			SELECT 0
			RETURN;
		END

	SET XACT_ABORT ON;

	BEGIN TRY

	BEGIN TRANSACTION;

			INSERT INTO [dbo].[tb_vo_voucher_order]
			(
				order_id,
				order_line_id,
				product_id,
				order_beneficiary_info_id,
				order_sn,
				order_line_sn,
				order_beneficiary_info_sn,
				voucher_id,
				voucher_response_code,
				creation_time
			)
		    SELECT 
			   o.id "OrderId", 
		       ol.id "OrderLineId",
			   ol.product_id "ProductId",
			   obi.id "OrderBeneficiaryInfoId",
               ROW_NUMBER()OVER(Order By ol.id) "OrderSN",
	           ROW_NUMBER()OVER(Partition By ol.id Order By ol.id) "OrderLineSN",
			   t.id "OrderBeneficiaryInfoSN",
			   NULL "VoucherId",
			   NULL "VoucherResponseCode",
			   GETDATE()
			FROM
			     [dbo].[tb_ob_order_basic] o WITH (NOLOCK) 
			JOIN [dbo].[tb_ol_order_line] ol WITH (NOLOCK) ON o.id = ol.order_id
			JOIN [dbo].[tb_obi_order_beneficiary_info] obi WITH (NOLOCK) ON ol.id = obi.order_line_id
			JOIN [dbo].[tb_t_tally] t ON obi.voucher_quantity >= t.id
			WHERE o.id = @OrderId

    COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
       IF @@TRANCOUNT > 0
       BEGIN
          ROLLBACK TRANSACTION
       END;

	   THROW;
	END CATCH

	SET NOCOUNT, XACT_ABORT OFF;

END