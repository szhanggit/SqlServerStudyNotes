

CREATE PROCEDURE spSyncThirdPartyOrder
    @ErrorMessage NVARCHAR(4000) OUTPUT ,
    @ErrorLine INT OUTPUT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY

            INSERT  INTO dbo.EXT_GR_VoucherInfo
                    ( Id ,
                      Ecode ,
                      ExpiryDate ,
                      FinBookingCurrency ,
                      FinBookingValue ,
                      Vstatus
                    )
                    SELECT  lo.VoucherId ,
                            ro.ThirdPartyVoucherNumber ,
                            N'' ,
                            N'' ,
                            N'' ,
                            N'2'
                    FROM    ( SELECT    t1.OrderId ,
                                        t5.ProductCode ,
                                        t6.ExtendId AS VoucherId,
                                        ROW_NUMBER() OVER ( PARTITION BY t1.OrderId,
                                                            t5.ProductCode,
                                                            t2.Mobile,
                                                            t2.Email ORDER BY t6.Id ) AS RN ,
                                        ISNULL(t2.Mobile, '')
                                        + ISNULL(t2.Email, '') AS OBI
                              FROM      dbo.OrderLine AS t1 WITH ( NOLOCK )
                                        JOIN dbo.OrderBeneficiaryInfo AS t2
                                        WITH ( NOLOCK ) ON t2.OrderLineId = t1.Id
                                        JOIN dbo.ClientQuotationProduct AS t3
                                        WITH ( NOLOCK ) ON t3.Id = t1.ClientQuotationProductId
                                        JOIN dbo.ProductVersion AS t4 WITH ( NOLOCK ) ON t4.Id = t3.ProductVersionId
                                        JOIN dbo.Product AS t5 WITH ( NOLOCK ) ON t5.Id = t4.ProductId
                                        JOIN dbo.Voucher AS t6 WITH ( NOLOCK ) ON t6.BeneficiaryInfoId = t2.Id
                                        JOIN dbo.[Order] AS t7 WITH ( NOLOCK ) ON t7.Id = t1.OrderId
                              WHERE     t7.ExecutingStatus = 9
                                        AND t7.Status = 32
                            ) AS lo
                            JOIN ( SELECT   OrderId ,
                                            ProductCode ,
                                            ThirdPartyVoucherNumber ,
                                            ROW_NUMBER() OVER ( PARTITION BY OrderId,
                                                              ProductCode,
                                                              Mobile, Email ORDER BY ThirdPartyVoucherNumber ) AS RN ,
                                            ISNULL(Mobile, '') + ISNULL(Email,
                                                              '') AS OBI
                                   FROM     dbo.VoucherSupplierSyncOrderBuffer_TX2
                                 ) AS ro ON lo.OrderId = ro.OrderId
                                            AND lo.ProductCode = ro.ProductCode
                                            AND lo.RN = ro.RN
                                            AND ro.OBI = lo.OBI

            UPDATE  t1
            SET     ExecutingStatus = 4
            FROM    dbo.[Order] AS t1
                    JOIN dbo.VoucherSupplierSyncOrderBuffer_TX2 AS t2 ON t1.Id = t2.OrderId
            WHERE   t1.ExecutingStatus = 9
					AND t1.Status = 32

            TRUNCATE TABLE VoucherSupplierSyncOrderBuffer_TX2

        END TRY
        BEGIN CATCH
            SELECT  @ErrorMessage = ERROR_MESSAGE()
            SELECT  @ErrorLine = ERROR_LINE()

            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END
