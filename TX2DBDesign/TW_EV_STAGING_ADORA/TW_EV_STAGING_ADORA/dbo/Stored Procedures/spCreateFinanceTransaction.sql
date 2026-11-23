
CREATE PROCEDURE [dbo].[spCreateFinanceTransaction]
@SessionId VARCHAR(50), 
@TranType INT
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
                        '000000000000000' AS MerchantCode ,
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


		IF	@TranType = 116			
			UPDATE AccountLETrans
			set TransLEStatus = 2		
			where TransSessionId = @SessionId;
		ELSE
			UPDATE AccountLETrans
			set TransLEStatus = 4		
			where TransSessionId = @SessionId;	

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
END;

