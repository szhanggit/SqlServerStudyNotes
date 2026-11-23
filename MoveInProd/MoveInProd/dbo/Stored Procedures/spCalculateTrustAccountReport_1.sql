

CREATE PROCEDURE [dbo].[spCalculateTrustAccountReport]
    @ErrorMessage NVARCHAR(4000) OUTPUT ,
    @ErrorLine INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY

            INSERT  INTO dbo.EXT_TW_TrustAccountReportHistory
                    ( ReportType ,
                      OrderLineId ,
                      PublishedOn ,
                      ProductName ,
                      Brand ,
                      ProgramId ,
                      VoucherNumber ,
                      VoucherStatus ,
                      LastTranOn ,
                      ConsumeTime ,
                      ConsumeMerchantCode ,
                      ConsumeShopCode ,
                      ReportDate ,
                      ReportBatchNo ,
                      CreatedOn
			        )
                    SELECT  t1.ReportType ,
                            t1.OrderLineId ,
                            t1.PublishedOn ,
                            t1.ProductName ,
                            t1.Brand ,
                            t1.ProgramId ,
                            t1.VoucherNumber ,
                            t1.VoucherStatus ,
                            t1.LastTranOn ,
                            t1.ConsumeTime ,
                            t1.ConsumeMerchantCode ,
                            t1.ConsumeShopCode ,
                            t1.ReportDate ,
                            t1.ReportBatchNo ,
                            GETDATE()
                    FROM    dbo.EXT_TW_TrustAccountReportCurrent AS t1
                            LEFT JOIN dbo.EXT_TW_TrustAccountReport AS t2 ON t1.ReportBatchNo = t2.ReportBatchNo
                    WHERE   ( t1.ReportType = 1
                              OR t1.ReportType = 2
                            )
                            AND t2.Id IS NULL
        
            INSERT  INTO dbo.EXT_TW_TrustAccountReport
                    ( ReportType ,
                      OrderLineId ,
                      PublishedOn ,
                      Brand ,
                      TrustAccountBatchNo ,
                      TrustAccountBank ,
                      GuaranteedStartDate ,
                      GuaranteedEndDate ,
                      IssuedQuantity ,
                      UsedQuantity ,
                      TrashedQuantity ,
                      ActiveQuantity ,
                      TrustAccountAmount ,
                      BankCommission ,
                      GuaranteedAmount ,
                      ReportDate ,
                      ReportBatchNo ,
                      CreatedOn
		            )
                    SELECT  tarc.ReportType ,
                            tarc.OrderLineId ,
                            tarc.PublishedOn ,
                            tarc.Brand ,
                            olta.TrustAccountBatchNo ,
                            olta.TrustAccountBank ,
                            CONVERT(INT, CONVERT(VARCHAR(20), tarc.PublishedOn, 112)) AS GuaranteedStartDate ,
                            CONVERT(INT, CONVERT(VARCHAR(20), DATEADD(yy, 1,
                                                              tarc.PublishedOn), 112)) AS GuaranteedEndDate ,
                            ol.TotalQuantity AS IssuedQuantity ,
                            tarc.[32] AS UsedQuantity ,
                            tarc.[8] AS TrashedQuantity ,
                            ol.TotalQuantity - tarc.[32] - tarc.[8] AS ActiveQuantity ,
                            olta.TrustAccountAmount ,
                            ( ol.TotalQuantity - tarc.[32] - tarc.[8] )
                            * olta.TrustAccountAmount * olta.TrustAccountFee
                            * ( DATEDIFF(DAY, CASE ReportType
                                                WHEN 1 THEN PublishedOn
                                                ELSE GETDATE()
                                              END,
                                         DATEADD(dd,
                                                 -DAY(CASE ReportType
                                                        WHEN 1
                                                        THEN PublishedOn
                                                        ELSE GETDATE()
                                                      END),
                                                 DATEADD(m, 1,
                                                         CASE ReportType
                                                           WHEN 1
                                                           THEN PublishedOn
                                                           ELSE GETDATE()
                                                         END))) + 1 ) / 365.0 AS BankCommission ,
                            ( ol.TotalQuantity - tarc.[32] - tarc.[8] )
                            * olta.TrustAccountAmount AS GuaranteedAmount ,
                            ReportDate ,
                            ReportBatchNo ,
                            GETDATE() AS CreatedOn
                    FROM    ( SELECT    t1.ReportType ,
                                        t1.OrderLineId ,
                                        t1.PublishedOn ,
                                        t1.Brand ,
                                        t1.VoucherNumber ,
                                        t1.VoucherStatus ,
                                        t1.ReportDate ,
                                        t1.ReportBatchNo
                              FROM      EXT_TW_TrustAccountReportCurrent AS t1
                                        LEFT JOIN dbo.EXT_TW_TrustAccountReport
                                        AS t2 ON t1.ReportBatchNo = t2.ReportBatchNo
                              WHERE     t2.Id IS NULL
                            ) AS t3 PIVOT ( COUNT(VoucherNumber) FOR VoucherStatus IN ( [1],
                                                              [32], [8] ) ) AS tarc
                            JOIN dbo.EXT_TW_OrderLineTrustAccount AS olta WITH ( NOLOCK ) ON tarc.OrderLineId = olta.Id
                            JOIN dbo.OrderLine AS ol WITH ( NOLOCK ) ON ol.Id = olta.Id

            UPDATE  olta
            SET     ReportStartTime = tar.CreatedOn
            FROM    dbo.EXT_TW_OrderLineTrustAccount AS olta
                    JOIN dbo.EXT_TW_TrustAccountReport AS tar ON olta.Id = tar.OrderLineId
            WHERE   tar.ReportType = 1

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
