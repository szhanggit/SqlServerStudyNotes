CREATE PROCEDURE [dbo].[sp_sel_voucher_order_beneficiary_info_seq]
	@OrderId INT,
	@OrdeLineId INT,
	@OrderBeneficiaryInfoId INT,
	@SeqStart INT,
	@SeqEnd INT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

	SELECT 
		order_id "OrderId",
		order_line_id "OrderLineId",
		order_beneficiary_info_id "OrderBeneficiaryInfoId",
		order_beneficiary_info_sn "Sequence"
	FROM [dbo].[tb_vo_voucher_order] 
	WHERE order_id = @OrderId
	AND order_line_id = @OrdeLineId
	AND order_beneficiary_info_id = @OrderBeneficiaryInfoId
	AND order_beneficiary_info_sn BETWEEN @SeqStart AND @SeqEnd
	ORDER BY order_beneficiary_info_sn
				 			 
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