
CREATE PROCEDURE [dbo].[spGetReimbursementById]
    @ReimbursementId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT  Reimbursement.* ,
                Merchant.Name AS MerchantName ,
                Merchant.ReimbursementTaxType ,
                Merchant.ReimbursementReceivers
        FROM    Reimbursement WITH ( NOLOCK )
                INNER JOIN Merchant WITH ( NOLOCK ) ON Reimbursement.MerchantId = Merchant.Id
        WHERE   Reimbursement.Status = 1
                AND Reimbursement.CreationWay = 1
                AND Reimbursement.NotificationId IS NULL
                AND Reimbursement.Id = @ReimbursementId
    END

