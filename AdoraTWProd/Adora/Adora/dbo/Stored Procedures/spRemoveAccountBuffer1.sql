



CREATE PROC spRemoveAccountBuffer1 @TaskId AS NVARCHAR(50)
AS
Begin
    SET NOCOUNT ON;
    BEGIN TRY	
        BEGIN TRANSACTION; 
        INSERT  INTO dbo.AccountBuffer2
                ( TaskId ,
                  AccountNumber ,
                  ProgramId ,
                  ProductId ,
                  ExternalOrderId ,
                  AccountNumberHashed ,
                  BalanceAvailable ,
                  BalanceFrozen ,
                  ValueType ,
                  TopupMode ,
                  Status ,
                  Checksum ,
                  TranCount ,
                  TranAmountAccumulated ,
                  AcceptanceLoopId ,
                  RestrictionId ,
                  ExpirationPolicyId ,
                  Password ,
                  ActiveFrom ,
                  ActiveTo ,
                  CreatedOn ,
                  LastTranOn ,
                  LastTranDate ,
                  LastTranTime ,
                  BlockedOn ,
                  ActivatedOn ,
                  ExpiredOn ,
                  ModifyVersion ,
                  AccountNumberLength ,
                  AccountGUID ,
                  IsNotifyClient ,
                  ClientNotificationProviderCode ,
                  ConsumeTime ,
                  ConsumeMerchantCode ,
                  ConsumeShopCode ,
                  ProgramCode ,
                  ConsumeTerminalSSN ,
                  PinCode
                )
                SELECT  TaskId ,
                        AccountNumber ,
                        ProgramId ,
                        ProductId ,
                        ExternalOrderId ,
                        AccountNumberHashed ,
                        BalanceAvailable ,
                        BalanceFrozen ,
                        ValueType ,
                        TopupMode ,
                        Status ,
                        Checksum ,
                        TranCount ,
                        TranAmountAccumulated ,
                        AcceptanceLoopId ,
                        RestrictionId ,
                        ExpirationPolicyId ,
                        Password ,
                        ActiveFrom ,
                        ActiveTo ,
                        CreatedOn ,
                        LastTranOn ,
                        LastTranDate ,
                        LastTranTime ,
                        BlockedOn ,
                        ActivatedOn ,
                        ExpiredOn ,
                        ModifyVersion ,
                        AccountNumberLength ,
                        AccountGUID ,
                        IsNotifyClient ,
                        ClientNotificationProviderCode ,
                        ConsumeTime ,
                        ConsumeMerchantCode ,
                        ConsumeShopCode ,
                        ProgramCode ,
                        ConsumeTerminalSSN ,
                        PinCOde
                FROM    dbo.AccountBuffer1
                WHERE   TaskId = @TaskId;

        DELETE  FROM dbo.AccountBuffer1
        WHERE   TaskId = @TaskId;


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
