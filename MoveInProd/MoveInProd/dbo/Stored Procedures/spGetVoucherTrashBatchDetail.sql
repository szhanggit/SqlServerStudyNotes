
CREATE PROCEDURE [dbo].[spGetVoucherTrashBatchDetail]
    @VoucherTrashBatchId INT
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT  VoucherNumber ,
                ExpiryDate
        FROM    dbo.VoucherTrashBatchDetail WITH ( NOLOCK )
        WHERE   VoucherTrashBatchId = @VoucherTrashBatchId
    END
