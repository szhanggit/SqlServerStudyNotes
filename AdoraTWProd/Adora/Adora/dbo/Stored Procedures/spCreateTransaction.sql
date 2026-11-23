

CREATE PROC spCreateTransaction
    @SessionId AS NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY	

        BEGIN TRANSACTION;
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
                FROM    dbo.TransactionBuffer
                WHERE   SessionId = @SessionId;	

        DELETE  FROM dbo.TransactionBuffer
        WHERE   SessionId = @SessionId;	 


        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);  
        DECLARE @ErrorSeverity INT;  
        DECLARE @ErrorState INT;  
  
        SELECT  @ErrorMessage = ERROR_MESSAGE() ,
                @ErrorSeverity = ERROR_SEVERITY() ,
                @ErrorState = ERROR_STATE();  
        RAISERROR (@ErrorMessage,  -- Message text.  
				   @ErrorSeverity, -- Severity.  
				   @ErrorState     -- State.  
				   );  

        IF @@TRANCOUNT > 0
            ROLLBACK;
    END CATCH;
END

