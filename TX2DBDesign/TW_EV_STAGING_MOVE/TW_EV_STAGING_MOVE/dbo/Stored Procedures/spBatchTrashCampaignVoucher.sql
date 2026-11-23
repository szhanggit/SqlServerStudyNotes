
CREATE PROCEDURE [dbo].[spBatchTrashCampaignVoucher]
	@SessionId varchar(50)
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY
			UPDATE v SET v.STATUS = 8 
			FROM voucher v INNER JOIN BatchProcessedVouchers BPV ON v.Id = BPV.VoucherId 
			WHERE BPV.SessionId = @SessionId
			
			DELETE FROM BatchProcessedVouchers WHERE SessionId = @SessionId
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END

