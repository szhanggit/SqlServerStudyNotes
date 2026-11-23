
/*
exec [spCreateAccount] '1d2e212a45774252b9530bf897d8f42d'
*/

CREATE PROC spCreateAccount
    @SessionId AS NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE  TOP(3000)  dbo.AccountBuffer2
    SET     SessionId = @SessionId ,
            SessionTime = GETUTCDATE()
    WHERE   SessionId IS NULL;
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
            SessionId ,
            SessionTime ,
            ProgramCode ,
            ConsumeTerminalSSN ,
            PinCode,
			SequenceNumber
    FROM    AccountBuffer2
    WHERE   SessionId = @SessionId; 

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT  INTO dbo.Account
                ( AccountNumber ,
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
                  ConsumeShopCode,
                  ConsumeTerminalSSN,
                  BalanceInitialized,
                  PinCode,
				  SequenceNumber
                )
                SELECT  AccountNumber ,
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
                        ConsumeTerminalSSN ,
                        BalanceAvailable ,
                        PinCode,
						SequenceNumber
                FROM    dbo.AccountBuffer2
                WHERE   SessionId = @SessionId;

        INSERT  INTO dbo.AccountKey
                ( AccountNumber ,
                  ProgramId
                )
                SELECT  AccountNumber ,
                        ProgramId
                FROM    AccountBuffer2
                WHERE   SessionId = @SessionId;	

        DELETE  FROM AccountBuffer2
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
            BEGIN	
			 
                ROLLBACK;
            END;
            
    END CATCH;
END

