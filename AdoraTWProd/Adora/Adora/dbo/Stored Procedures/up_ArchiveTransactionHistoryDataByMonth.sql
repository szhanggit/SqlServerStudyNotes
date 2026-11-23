-- =============================================
-- Author:    Zhu Jianhua
-- Create date: 2016-12-01
-- Description:   Archive TransactionHistory data by month
-- =============================================
CREATE PROCEDURE up_ArchiveTransactionHistoryDataByMonth 
    -- Add the parameters for the stored procedure here
    @EndDate INT
AS
    BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
        SET NOCOUNT ON;
    
        DECLARE @SelectRowNumber INT
        DECLARE @InsertRowNumber INT
        DECLARE @DeleteRowNumber INT
    -- Insert statements for procedure here
        BEGIN TRAN

        BEGIN TRY  
       
       -- Check Row Nember
            SELECT  @SelectRowNumber = COUNT(1)
            FROM    [dbo].[TransactionHistory]
            WHERE   [TranLocalDate] <= @EndDate;
            PRINT '@SelectRowNumber = '
                + CAST(@SelectRowNumber AS VARCHAR(20))

            INSERT  INTO [dbo].[TransactionArchive]
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
                      [Status] ,
                      TranAmount ,
                      RefundedAmount ,
                      ResponseCode ,
                      IsCleared ,
                      NodeNum ,
                      CallerIP ,
                      Channel ,
                      [Parameters] ,
                      TranCode ,
                      TranCodeRef ,
                      TranGUID ,
                      TranGUIDRef ,
                      ModifyVersion ,
                      BalanceAvailable ,
                      BalanceFrozen ,
                      [Checksum] ,
                      SecurityKeyId ,
                      Rsv1 ,
                      Rsv2 ,
                      Rsv3
                    )
                    SELECT  AccountNumber ,
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
                            [Status] ,
                            TranAmount ,
                            RefundedAmount ,
                            ResponseCode ,
                            IsCleared ,
                            NodeNum ,
                            CallerIP ,
                            Channel ,
                            [Parameters] ,
                            TranCode ,
                            TranCodeRef ,
                            TranGUID ,
                            TranGUIDRef ,
                            ModifyVersion ,
                            BalanceAvailable ,
                            BalanceFrozen ,
                            [Checksum] ,
                            SecurityKeyId ,
                            Rsv1 ,
                            Rsv2 ,
                            Rsv3
                    FROM    [dbo].[TransactionHistory]
                    WHERE   [TranLocalDate] <= @EndDate;
           
            SET @InsertRowNumber = @@rowcount;

            PRINT '@InsertRowNumber = '
                + CAST(@InsertRowNumber AS VARCHAR(20))

       -- Check Insert Row Number
            IF @SelectRowNumber != @InsertRowNumber
                BEGIN
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
              
            DELETE  FROM [dbo].[TransactionHistory]
            WHERE   [TranLocalDate] <= @EndDate; 

            SET @DeleteRowNumber = @@rowcount;

            PRINT '@DeleteRowNumber = '
                + CAST(@DeleteRowNumber AS VARCHAR(20))

       -- Check Insert Row Number
            IF @SelectRowNumber != @DeleteRowNumber
                BEGIN
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
           
            COMMIT TRANSACTION;
        END TRY

        BEGIN CATCH       
            ROLLBACK TRANSACTION;    
        END CATCH
    END
