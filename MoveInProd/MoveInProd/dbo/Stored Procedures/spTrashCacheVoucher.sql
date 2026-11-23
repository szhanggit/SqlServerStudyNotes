
-- Stored Procedure

CREATE PROCEDURE spTrashCacheVoucher
    @ProductId INT ,
    @BatchNo VARCHAR(20) ,
    @VoucherReservationCodeId INT ,
    @CreatedBy NVARCHAR(50) ,
    @ResponseCode VARCHAR(10) OUTPUT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        SET @ResponseCode = '0000'
        IF EXISTS ( SELECT  *
                    FROM    dbo.Product
                    WHERE   CanIssue = 1
                            AND Id = @ProductId )
            BEGIN 
                SET @ResponseCode = 'M0114'
                RETURN
            END

        DECLARE @VoucherTrashBatchId INT
        BEGIN TRAN

        BEGIN TRY
            INSERT  INTO dbo.VoucherTrashBatch
                    ( BatchNo ,
                      VoucherCount ,
                      VoucherReservationCodeId ,
                      ProductId ,
                      CreatedOn ,
                      CreatedBy
			        )
            VALUES  ( @BatchNo ,
                      0 ,
                      @VoucherReservationCodeId ,
                      @ProductId ,
                      GETDATE() ,
                      @CreatedBy 
			        )
            SET @VoucherTrashBatchId = SCOPE_IDENTITY()
            UPDATE  t1
            SET     Status = 8 ,
                    Memo = CAST(@VoucherTrashBatchId AS NVARCHAR(1000))
            FROM    dbo.Voucher AS t1
                    JOIN dbo.VoucherReservationBatch AS t2 ON t2.Id = t1.ReservationBatchId
            WHERE   t1.ProductId = @ProductId
                    AND t1.Status = 256
                    AND t2.VoucherReservationCodeId = @VoucherReservationCodeId
            UPDATE  dbo.VoucherTrashBatch
            SET     VoucherCount = @@ROWCOUNT
            WHERE   Id = @VoucherTrashBatchId
            INSERT  INTO dbo.VoucherTrashBatchDetail
                    ( VoucherTrashBatchId ,
                      VoucherId ,
                      VoucherNumber ,
                      ExpiryDate
				    )
                    SELECT  @VoucherTrashBatchId ,
                            t1.Id ,
                            t1.VoucherNumber ,
                            t1.ExpiryDate
                    FROM    dbo.Voucher AS t1 WITH ( NOLOCK )
                            JOIN dbo.VoucherReservationBatch AS t2 ON t2.Id = t1.ReservationBatchId
                    WHERE   t1.ProductId = @ProductId
                            AND t1.Status = 8
                            AND t2.VoucherReservationCodeId = @VoucherReservationCodeId
                            AND t1.Memo = CAST(@VoucherTrashBatchId AS NVARCHAR(1000))
        END TRY
        BEGIN CATCH
            SET @ResponseCode = '9999'
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END

