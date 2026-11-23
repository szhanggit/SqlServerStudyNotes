
CREATE PROCEDURE spInsertMultiAccountsTransaction
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
                    SELECT  t2.AccountNumber ,
                            t1.ProgramCode ,
                            t1.MerchantCode ,
                            RIGHT(REPLICATE('0', 9)
                                  + NEXT VALUE FOR HostSsn_Sequence, 9) ,
                            t1.TerminalSSN + CAST(t2.Id AS VARCHAR) ,
                            t1.TranUtcDateTime ,
                            t1.TranUtcDateTimeL ,
                            t1.TranTerminalDateTime ,
                            t1.ShopCode ,
                            t1.TerminalCode ,
                            t1.TranType ,
                            t2.TranAmount ,
                            t1.NodeNum ,
                            t1.CallerIP ,
                            t1.Channel ,
                            NULL ,
                            t1.ProgramCode + t1.MerchantCode
                            + CAST(t1.TranUtcDate AS VARCHAR)
                            + RIGHT(REPLICATE('0', 9)
                                    + NEXT VALUE FOR HostSsn_Sequence, 9) ,
                            t2.TranCodeRef ,
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
                            JOIN dbo.MultiAccountsTransactionDetail AS t2 WITH ( NOLOCK ) ON t2.MultiAccountsTransactionId = t1.Id
                    WHERE   t1.Id = @MultiAccountsTransactionId

            UPDATE  t1
            SET     TranCode = t2.TranCode
            FROM    dbo.MultiAccountsTransactionDetail AS t1 WITH ( ROWLOCK )
                    JOIN dbo.[Transaction] AS t2 WITH ( NOLOCK ) ON t2.AccountNumber = t1.AccountNumber
                                                              AND t2.MultiAccountsTransactionId = t1.MultiAccountsTransactionId
            WHERE   t1.MultiAccountsTransactionId = @MultiAccountsTransactionId

        END TRY
        BEGIN CATCH

            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;

        SELECT  *
        FROM    dbo.[Transaction] WITH ( NOLOCK )
        WHERE   MultiAccountsTransactionId = @MultiAccountsTransactionId
    END
