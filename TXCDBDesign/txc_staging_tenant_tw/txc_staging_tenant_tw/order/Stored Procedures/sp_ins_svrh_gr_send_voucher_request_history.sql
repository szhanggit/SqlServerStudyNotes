CREATE PROCEDURE [order].[sp_ins_svrh_gr_send_voucher_request_history]
	@RequestId NVARCHAR(64),
	@Id INT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT OFF;

    BEGIN TRY

	BEGIN TRANSACTION;
	
	INSERT INTO [order].tb_gr_svrh_send_voucher_request_history
	(
		request_Id,
		gr_client_order_line_id
	)
	VALUES
	(
		@RequestId,
		@Id
	)
	
	COMMIT TRANSACTION;
				 			 
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