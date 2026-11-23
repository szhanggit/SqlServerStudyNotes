
CREATE PROCEDURE spInsertFailureReversalTransaction
    @MultiAccountsTransactionId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRAN
        BEGIN TRY

            INSERT  INTO [dbo].[Transaction]
                    ( [AccountNumber] ,
                      [ProgramCode] ,
                      [MerchantCode] ,
                      [HostSSN] ,
                      [TerminalSSN] ,
                      [TranUtcDateTime] ,
                      [TranUtcDateTimeL] ,
                      [TranTerminalDateTime] ,
                      [ShopCode] ,
                      [TerminalCode] ,
                      [TranType] ,
                      [TranAmount] ,
                      [NodeNum] ,
                      [CallerIP] ,
                      [Channel] ,
                      [Parameters] ,
                      [TranCode] ,
                      [TranCodeRef] ,
                      [TranGUID] ,
                      [TranRealDateTime] ,
                      [SettleDate] ,
                      [TranUtcDate] ,
                      [TranLocalDate] ,
                      [TranLocalDateTime] ,
                      [Rsv1] ,
                      [Rsv2] ,
                      [Rsv3] ,
                      ShiftCode ,
                      BusinessDay ,
                      MultiAccountsTransactionId
		            )
                    SELECT  t4.AccountNumber ,
                            t1.ProgramCode ,
                            t1.MerchantCode ,
                            RIGHT(REPLICATE('0', 9)
                                  + NEXT VALUE FOR HostSsn_Sequence, 9) ,
                            t1.TerminalSSN + CAST(t4.Id AS VARCHAR) ,
                            t1.TranUtcDateTime ,
                            t1.TranUtcDateTimeL ,
                            t1.TranTerminalDateTime ,
                            t1.ShopCode ,
                            t1.TerminalCode ,
                            IIF(t1.TranType = 603, 203, t1.TranType) ,
                            t4.TranAmount ,
                            t1.NodeNum ,
                            t1.CallerIP ,
                            t1.Channel ,
                            NULL ,
                            t1.ProgramCode + t1.MerchantCode
                            + CAST(t1.TranUtcDate AS VARCHAR)
                            + RIGHT(REPLICATE('0', 9)
                                    + NEXT VALUE FOR HostSsn_Sequence, 9) ,
                            t4.TranCode ,
                            NEWID() ,
                            t1.TranUtcDateTime ,
                            NULL ,
                            t1.TranUtcDate ,
                            t1.TranLocalDate ,
                            t1.TranLocalDateTime ,
                            t1.Rsv1 ,
                            t1.Rsv2 ,
                            t1.Rsv3 ,
                            t1.ShiftCode ,
                            t1.BusinessDay ,
                            t1.Id
                    FROM    dbo.MultiAccountsTransaction AS t1 WITH ( NOLOCK )
                            JOIN dbo.FailureReversalDetail AS t2 WITH ( NOLOCK ) ON t2.MultiAccountsTransactionId = t1.Id
                            JOIN dbo.MultiAccountsTransaction AS t3 WITH ( NOLOCK ) ON t1.ProgramCode = t3.ProgramCode
                                                              AND ISNULL(t1.MerchantCode,
                                                              '') = ISNULL(t3.MerchantCode,
                                                              '')
                                                              AND ISNULL(t1.ShopCode,
                                                              '') = ISNULL(t3.ShopCode,
                                                              '')
                                                              AND ISNULL(t1.TerminalCode,
                                                              '') = ISNULL(t3.TerminalCode,
                                                              '')
                                                              AND t1.BusinessDay = t3.BusinessDay
                                                              AND t1.ShiftCode = t3.ShiftCode
                                                              AND t2.TerminalSSNRef = t3.TerminalSSN
                            JOIN dbo.MultiAccountsTransactionDetail AS t4 WITH ( NOLOCK ) ON t4.MultiAccountsTransactionId = t3.Id
                    WHERE   t1.Id = @MultiAccountsTransactionId
                            AND t3.Status = 1
                            AND t4.TranCode IS NOT NULL

        END TRY
        BEGIN CATCH

            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;

        SELECT  t1.* ,
                t3.TerminalSSN AS TerminalSSNRef ,
                t3.Id AS MultiAccountsTransactionIdRef
        FROM    dbo.[Transaction] AS t1 WITH ( NOLOCK )
                JOIN dbo.MultiAccountsTransactionDetail AS t2 WITH ( NOLOCK ) ON t2.AccountNumber = t1.AccountNumber
                                                              AND t2.TranCode = t1.TranCodeRef
                JOIN dbo.MultiAccountsTransaction AS t3 WITH ( NOLOCK ) ON t3.Id = t2.MultiAccountsTransactionId
        WHERE   t1.MultiAccountsTransactionId = @MultiAccountsTransactionId
    END
