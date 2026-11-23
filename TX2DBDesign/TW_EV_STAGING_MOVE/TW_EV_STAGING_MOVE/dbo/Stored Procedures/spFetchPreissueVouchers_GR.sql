
CREATE PROCEDURE [dbo].[spFetchPreissueVouchers_GR]
    @ProductId INT ,
    @CacheNode TINYINT ,
    @Count INT ,
    @ReservationCodeId INT
AS
    BEGIN
        SET NOCOUNT ON;
        declare @timecutline   datetime;
		set @timecutline = DATEADD(DAY, 14, getdate())
		DECLARE @CurrentDate INT
		SET @CurrentDate = CAST(convert(varchar,getdate(),112) as int)
        BEGIN TRAN;
            WITH    UpdateVoucher
                      AS ( SELECT TOP ( @Count )
                                    [STATUS] ,
                                    [CacheNode]
                           FROM     [dbo].[Voucher] V
                                    JOIN [dbo].[VoucherReservationBatch] VRB ON V.ReservationBatchId = VRB.ID
                           WHERE    V.[BeneficiaryInfoId] IS NULL
                                    AND V.[CacheNode] IS NULL
                                    AND V.[Status] = 64
                                    AND V.[ProductId] = @ProductId
                                    AND VRB.VoucherReservationCodeId = @ReservationCodeId
									and (V.ExpiryDate >= @timecutline or V.ExpiryDate IS NULL)
									AND @CurrentDate >= VRB.AvailableStartDate
									AND VRB.AvailableEndDate >= @CurrentDate
                           ORDER BY v.ExpiryDate
                         )
            UPDATE  UpdateVoucher
            SET     [STATUS] = 128 ,
                    [CacheNode] = @CacheNode
	
        IF @@ERROR <> 0
            ROLLBACK TRAN
        ELSE
            COMMIT TRAN
    END
