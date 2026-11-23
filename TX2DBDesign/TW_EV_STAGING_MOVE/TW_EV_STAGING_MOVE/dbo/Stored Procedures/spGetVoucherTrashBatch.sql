
CREATE PROCEDURE [dbo].[spGetVoucherTrashBatch] @productId INT
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT  Id AS VoucherTrashBatchId ,
                CreatedOn AS TrashDate ,
                VoucherCount AS TrashedCount
        FROM    dbo.VoucherTrashBatch
        WHERE   ProductId = @productId
    END
