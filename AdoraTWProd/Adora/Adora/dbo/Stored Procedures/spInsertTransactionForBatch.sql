
CREATE PROCEDURE spInsertTransactionForBatch
    @BatchTransactionTaskId BIGINT ,
    @IsSuccess BIT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY

            INSERT  INTO dbo.[Transaction]
                    ( AccountNumber ,
                      ProgramCode ,
                      MerchantCode ,
                      HostSSN ,
                      TerminalSSN ,
                      TranUtcDate ,
                      TranUtcDateTimeL ,
                      TranUtcDateTime ,
                      TranLocalDate ,
                      TranLocalDateTime ,
                      TranTerminalDateTime ,
                      SettleDate ,
                      TranRealDateTime ,
                      ShopCode ,
                      TerminalCode ,
                      TranType ,
                      Status ,
                      TranAmount ,
                      RefundedAmount ,
                      ResponseCode ,
                      IsCleared ,
                      NodeNum ,
                      CallerIP ,
                      Channel ,
                      Parameters ,
                      TranCode ,
                      TranCodeRef ,
                      TranGUID ,
                      TranGUIDRef ,
                      ModifyVersion ,
                      BalanceAvailable ,
                      BalanceFrozen ,
                      Checksum ,
                      SecurityKeyId ,
                      Rsv1 ,
                      Rsv2 ,
                      Rsv3
		            )
                    SELECT  tb.AccountNumber ,
                            tb.ProgramCode ,
                            tb.MerchantCode ,
                            tb.HostSSN ,
                            tb.TerminalSSN ,
                            tb.TranUtcDate ,
                            tb.TranUtcDateTimeL ,
                            tb.TranUtcDateTime ,
                            tb.TranLocalDate ,
                            tb.TranLocalDateTime ,
                            tb.TranTerminalDateTime ,
                            tb.SettleDate ,
                            tb.TranRealDateTime ,
                            tb.ShopCode ,
                            tb.TerminalCode ,
                            tb.TranType ,
                            tb.Status ,
                            tb.TranAmount ,
                            tb.RefundedAmount ,
                            tb.ResponseCode ,
                            tb.IsCleared ,
                            tb.NodeNum ,
                            tb.CallerIP ,
                            tb.Channel ,
                            tb.Parameters ,
                            tb.TranCode ,
                            tb.TranCodeRef ,
                            tb.TranGUID ,
                            tb.TranGUIDRef ,
                            tb.ModifyVersion ,
                            tb.BalanceAvailable ,
                            tb.BalanceFrozen ,
                            tb.Checksum ,
                            tb.SecurityKeyId ,
                            tb.Rsv1 ,
                            tb.Rsv2 ,
                            tb.Rsv3
                    FROM    dbo.TransactionBufferForBatch AS tb WITH ( NOLOCK )
                            INNER JOIN dbo.BatchTransactionDetail AS btd WITH ( NOLOCK ) ON tb.BatchTransactionDetailId = btd.Id
                    WHERE   btd.BatchTransactionTaskId = @BatchTransactionTaskId

            UPDATE  btt
            SET     [Status] = 3 ,
                    ExecuteEndTime = GETDATE() ,
                    SuccessVoucherCount = ISNULL(btts.SuccessVoucherCount, 0) ,
                    FailVoucherCount = TotalVoucherCount
                    - ISNULL(btts.SuccessVoucherCount, 0)
            FROM    BatchTransactionTask AS btt
                    LEFT JOIN ( SELECT  BatchTransactionTaskId ,
                                        COUNT(*) AS SuccessVoucherCount
                                FROM    dbo.BatchTransactionDetail AS btd WITH ( NOLOCK )
                                WHERE   ResponseCode = '0000'
                                GROUP BY BatchTransactionTaskId
                              ) AS btts ON btts.BatchTransactionTaskId = btt.Id
            WHERE   btt.Id = @BatchTransactionTaskId

            DELETE  FROM tb
            FROM    dbo.TransactionBufferForBatch AS tb
                    INNER JOIN dbo.BatchTransactionDetail AS btd WITH ( NOLOCK ) ON tb.BatchTransactionDetailId = btd.Id
            WHERE   btd.BatchTransactionTaskId = @BatchTransactionTaskId

            SET @IsSuccess = 1
		 
        END TRY
        BEGIN CATCH
            SET @IsSuccess = 0
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END
