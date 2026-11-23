
-- =============================================
-- @ReportType: 1: Order 2: Monthly 3: Daily
-- =============================================

CREATE PROCEDURE [dbo].[spTrustAccountReport]
    @ReportType TINYINT ,
    @ErrorMessage NVARCHAR(4000) OUTPUT ,
    @ErrorLine INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        IF @ReportType = 3
            AND DAY(GETDATE()) = 1
            BEGIN
                SET @ReportType = 2
            END

        DECLARE @ReportDate DATETIME
        IF @ReportType = 3
            BEGIN
                SET @ReportDate = DATEADD(dd, -1, GETDATE())
            END
        IF @ReportType = 2
            BEGIN
                SET @ReportDate = GETDATE()
            END

        IF @ReportType = 1
            BEGIN
                IF EXISTS ( SELECT  *
                            FROM    dbo.EXT_TW_OrderLineTrustAccount AS t1
                                    WITH ( NOLOCK )
                                    JOIN dbo.OrderLine AS t2 WITH ( NOLOCK ) ON t2.Id = t1.Id
                                    JOIN dbo.[Order] AS t3 WITH ( NOLOCK ) ON t3.Id = t2.OrderId
                                    JOIN dbo.EXT_TW_TrustAccountReportCurrent
                                    AS t4 WITH ( NOLOCK ) ON t1.Id = t4.OrderLineId
                            WHERE   t3.Status = 64
                                    AND t1.ReportStartTime IS NULL )
                    BEGIN 
                        DELETE  FROM t4
                        FROM    dbo.EXT_TW_OrderLineTrustAccount AS t1 WITH ( NOLOCK )
                                JOIN dbo.OrderLine AS t2 WITH ( NOLOCK ) ON t2.Id = t1.Id
                                JOIN dbo.[Order] AS t3 WITH ( NOLOCK ) ON t3.Id = t2.OrderId
                                JOIN dbo.EXT_TW_TrustAccountReportCurrent AS t4 ON t1.Id = t4.OrderLineId
                        WHERE   t3.Status = 64
                                AND t1.ReportStartTime IS NULL 

                        DELETE  FROM t4
                        FROM    dbo.EXT_TW_OrderLineTrustAccount AS t1 WITH ( NOLOCK )
                                JOIN dbo.OrderLine AS t2 WITH ( NOLOCK ) ON t2.Id = t1.Id
                                JOIN dbo.[Order] AS t3 WITH ( NOLOCK ) ON t3.Id = t2.OrderId
                                JOIN dbo.EXT_TW_TrustAccountReport AS t4 ON t1.Id = t4.OrderLineId
                        WHERE   t3.Status = 64
                                AND t1.ReportStartTime IS NULL 

                        DELETE  FROM t4
                        FROM    dbo.EXT_TW_OrderLineTrustAccount AS t1 WITH ( NOLOCK )
                                JOIN dbo.OrderLine AS t2 WITH ( NOLOCK ) ON t2.Id = t1.Id
                                JOIN dbo.[Order] AS t3 WITH ( NOLOCK ) ON t3.Id = t2.OrderId
                                JOIN dbo.EXT_TW_TrustAccountReportHistory AS t4 ON t1.Id = t4.OrderLineId
                        WHERE   t3.Status = 64
                                AND t1.ReportStartTime IS NULL 
                    END

                INSERT  INTO dbo.EXT_TW_TrustAccountReportCurrent
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
                          ReportBatchNo
                        )
                        SELECT  @ReportType AS ReportType ,
                                ol.Id AS OrderLineId ,
                                o.PublishDatetime AS PublishedOn ,
                                pv.ProductName ,
                                LEFT(p.ProductCode, 3) AS Brand ,
                                v.ProgramId ,
                                v.VoucherNumber ,
                                v.Status AS VoucherStatus ,
                                v.LastTranOn ,
                                v.ConsumeTime ,
                                v.ConsumeMerchantCode ,
                                v.ConsumeShopCode ,
                                CONVERT(INT, CONVERT(VARCHAR(20), o.PublishDatetime, 112)) AS ReportDate ,
                                CAST(@ReportType AS VARCHAR(20))
                                + CAST(ol.Id AS VARCHAR(20))
                                + CONVERT(VARCHAR(20), o.PublishDatetime, 112) AS ReportBatchNo
                        FROM    dbo.EXT_TW_OrderLineTrustAccount AS olta WITH ( NOLOCK )
                                JOIN dbo.OrderLine AS ol WITH ( NOLOCK ) ON ol.Id = olta.Id
                                JOIN dbo.[Order] AS o WITH ( NOLOCK ) ON o.Id = ol.OrderId
                                JOIN dbo.ClientQuotationProduct AS cqp WITH ( NOLOCK ) ON cqp.Id = ol.ClientQuotationProductId
                                JOIN dbo.ProductVersion AS pv WITH ( NOLOCK ) ON pv.Id = cqp.ProductVersionId
                                JOIN dbo.Product AS p WITH ( NOLOCK ) ON p.Id = pv.ProductId
                                JOIN dbo.OrderBeneficiaryInfo AS obi WITH ( NOLOCK ) ON obi.OrderLineId = ol.Id
                                JOIN dbo.Voucher AS v WITH ( NOLOCK ) ON v.BeneficiaryInfoId = obi.Id
                        WHERE   o.Status = 64
                                AND olta.ReportStartTime IS NULL

            END

        IF @ReportType = 2
            OR @ReportType = 3
            BEGIN

                IF EXISTS ( SELECT  *
                            FROM    dbo.EXT_TW_TrustAccountReportCurrent AS tarc
                                    LEFT   JOIN dbo.EXT_TW_TrustAccountReport
                                    AS tar ON tarc.ReportBatchNo = tar.ReportBatchNo
                            WHERE   tarc.ReportType = 1
                                    AND tar.Id IS NULL )
                    BEGIN  

                        EXEC dbo.spCalculateTrustAccountReport @ErrorMessage = @ErrorMessage OUTPUT,
                            @ErrorLine = @ErrorLine OUTPUT

                    END

                IF EXISTS ( SELECT  *
                            FROM    dbo.EXT_TW_TrustAccountReportCurrent AS tarc
                                    LEFT   JOIN dbo.EXT_TW_TrustAccountReport
                                    AS tar ON tarc.ReportBatchNo = tar.ReportBatchNo
                            WHERE   tarc.ReportType = 1
                                    AND tar.Id IS NULL )
                    BEGIN  

                        SELECT  @ErrorMessage = N'Order Report Failed'
                        SELECT  @ErrorLine = 0
                        RETURN;
                    END


                INSERT  INTO dbo.EXT_TW_TrustAccountReportCurrent
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
                          ReportBatchNo
                        )
                        SELECT  @ReportType AS ReportType ,
                                tarc.OrderLineId ,
                                tarc.PublishedOn ,
                                tarc.ProductName ,
                                tarc.Brand ,
                                tarc.ProgramId ,
                                tarc.VoucherNumber ,
                                v.Status AS VoucherStatus ,
                                v.LastTranOn ,
                                v.ConsumeTime ,
                                v.ConsumeMerchantCode ,
                                v.ConsumeShopCode ,
                                CONVERT(INT, CONVERT(VARCHAR(20), @ReportDate, 112)) AS ReportDate ,
                                CAST(@ReportType AS VARCHAR(20))
                                + CAST(tarc.OrderLineId AS VARCHAR(20))
                                + CONVERT(VARCHAR(20), @ReportDate, 112) AS ReportBatchNo
                        FROM    ( SELECT  DISTINCT
                                            OrderLineId ,
                                            PublishedOn ,
                                            ProductName ,
                                            Brand ,
                                            ProgramId ,
                                            VoucherNumber
                                  FROM      dbo.EXT_TW_TrustAccountReportCurrent
                                            WITH ( NOLOCK )
                                ) AS tarc
                                JOIN dbo.Voucher AS v WITH ( NOLOCK ) ON tarc.VoucherNumber = v.VoucherNumber
                                                              AND tarc.ProgramId = v.ProgramId
                        WHERE   GETDATE() <= DATEADD(yy, 1, tarc.PublishedOn)
               
                DELETE  FROM tarc
                FROM    dbo.EXT_TW_TrustAccountReportCurrent AS tarc
                        JOIN dbo.EXT_TW_TrustAccountReport AS tar WITH ( NOLOCK ) ON tarc.ReportBatchNo = tar.ReportBatchNo
				
            END

       
        EXEC dbo.spCalculateTrustAccountReport @ErrorMessage = @ErrorMessage OUTPUT,
            @ErrorLine = @ErrorLine OUTPUT
	      
			
    END


