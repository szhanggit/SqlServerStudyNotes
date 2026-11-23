
CREATE PROCEDURE dbo.spMoveOLAPBuffer2OfficialTables
    (
      @SessionId VARCHAR(50) ,
      @ErrorMessage NVARCHAR(4000) OUTPUT ,
      @ErrorLine INT OUTPUT
	)
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRAN
        BEGIN TRY
            DECLARE @maxId INT = 0
            DECLARE @lastSuccessOlapTranEndId BIGINT

            SELECT  @maxId = MAX(Id)
            FROM    dbo.OLAPSyncProcessLog
            WHERE   [Status] = 8

            SELECT  @lastSuccessOlapTranEndId = OlapTranEndId
            FROM    dbo.OLAPSyncProcessLog
            WHERE   Id = @maxId;

			DELETE FROM OLAPSyncTransactionBuffer
			WHERE Id <= @lastSuccessOlapTranEndId

			UPDATE TR SET TR.NWR = -1 * T.NWR
	        FROM dbo.OLAPSyncTransactionBuffer TR
	        JOIN dbo.[Transaction] T WITH(NOLOCK) ON T.AccountNumber = TR.AccountNumber AND T.TranCode = TR.TranCodeRef AND T.TranType <> 102

			UPDATE TR SET TR.NWR = -1 * T.NWR
	        FROM dbo.OLAPSyncTransactionBuffer TR
	        JOIN dbo.OLAPSyncTransactionBuffer T WITH(NOLOCK) ON T.AccountNumber = TR.AccountNumber AND T.TranCode = TR.TranCodeRef AND T.TranType <> 102


            DECLARE @TranCodeMappingTable TABLE
                (
                  Id BIGINT NOT NULL ,
                  AccountNumber [VARCHAR](50) NOT NULL ,
                  TranCode [VARCHAR](50) NOT NULL ,
                  UNIQUE ( AccountNumber, TranCode )
                ) 

            INSERT  INTO dbo.[Transaction]
                    ( AccountNumber ,
                      ProgramCode ,
                      MerchantCode ,
                      ShopCode ,
                      TranType ,
                      TranLocalDate ,
                      TranLocalDateTime ,
                      SettleDate ,
                      TranRealDateTime ,
                      Status ,
                      TranAmount ,
                      RefundedAmount ,
                      ResponseCode ,
                      Channel ,
                      TranCode ,
                      TranCodeRef ,
                      BalanceAvailable ,
                      BalanceFrozen ,
                      MerchantId ,
                      ShopId ,
                      ClientQuotationProductId ,
                      ProductId ,
                      OrderId ,
                      InvoiceToBeRequestedId ,
                      ClientQuotationPricingId ,
                      ReimbursementSchemeId ,
                      ReimbursementLineId ,
                      InvoiceValue ,
                      ReimbursementValue ,
                      Bill ,
                      ServiceFee ,
                      IIV ,
                      IV ,
                      Discount ,
                      IRV ,
                      RV ,
                      NWR ,
                      NWA ,
                      IEV ,
                      EV ,
                      NoShowPrice ,
                      NoShowCost ,
                      CostMarketing ,
                      CostEmployeeWelfare ,
                      CostTest ,
                      Rsv1 ,
                      Rsv2 ,
                      Rsv3 ,
                      TerminalSSN ,
                      ShiftCode ,
                      BusinessDay ,
                      TerminalCode ,
                      FNNWA ,
                      FNEV ,
                      FNDiscount ,
                      FNEVWithholdDiscount
			        )
            OUTPUT  inserted.Id ,
                    inserted.AccountNumber ,
                    Inserted.TranCode
                    INTO @TranCodeMappingTable
                    SELECT  AccountNumber ,
                            ProgramCode ,
                            MerchantCode ,
                            ShopCode ,
                            TranType ,
                            TranLocalDate ,
                            TranLocalDateTime ,
                            SettleDate ,
                            TranRealDateTime ,
                            Status ,
                            TranAmount ,
                            RefundedAmount ,
                            ResponseCode ,
                            Channel ,
                            TranCode ,
                            TranCodeRef ,
                            BalanceAvailable ,
                            BalanceFrozen ,
                            MerchantId ,
                            ShopId ,
                            ClientQuotationProductId ,
                            ProductId ,
                            OrderId ,
                            InvoiceToBeRequestedId ,
                            ClientQuotationPricingId ,
                            ReimbursementSchemeId ,
                            ReimbursementLineId ,
                            InvoiceValue ,
                            ReimbursementValue ,
                            Bill ,
                            ServiceFee ,
                            IIV ,
                            IV ,
                            Discount ,
                            IRV ,
                            RV ,
                            NWR ,
                            NWA ,
                            IEV ,
                            EV ,
                            NoShowPrice ,
                            NoShowCost ,
                            CostMarketing ,
                            CostEmployeeWelfare ,
                            CostTest ,
                            Rsv1 ,
                            Rsv2 ,
                            Rsv3 ,
                            TerminalSSN ,
                            ShiftCode ,
                            BusinessDay ,
                            TerminalCode ,
                            FNNWA ,
                            FNEV ,
                            FNDiscount ,
                            FNEVWithholdDiscount
                    FROM    dbo.OLAPSyncTransactionBuffer
                    WHERE   id > @lastSuccessOlapTranEndId
                            AND SessionId = @SessionId
            
                DECLARE @TranFeeIdTable TABLE
                (
                  Id BIGINT PRIMARY KEY
                ) 

            INSERT  INTO dbo.TransactionFee
                    ( TransactionId ,
                      ServiceFeeId ,
                      TranFee
				    )
            OUTPUT  Inserted.Id
                    INTO @TranFeeIdTable

                    SELECT t3.id ,
                            t1.ServiceFeeId ,
                            t1.TranFee
                    FROM    dbo.OLAPSyncTransactionFeeBuffer t1
                            JOIN dbo.OLAPSyncTransactionBuffer t2 ON t1.OLAPSyncTransactionBufferId = t2.Id
                            JOIN @TranCodeMappingTable t3 ON t2.AccountNumber = t3.AccountNumber
                                                             AND t2.TranCode = t3.TranCode
	        
			UPDATE T 
			SET T.Status = 2
			FROM dbo.OLAPSyncTransactionBuffer TR
			JOIN dbo.[Transaction] T ON T.AccountNumber = TR.AccountNumber AND TR.TranCodeRef = T.TranCode
			WHERE T.[Status] = 1
			AND TR.TranType <> 103
			AND TR.TranType <> 106
			AND T.TranType <> 104;

            DECLARE @MaxTranId BIGINT
            DECLARE @MaxTranFeeId BIGINT

            SELECT  @MaxTranId = MAX(id)
            FROM    @TranCodeMappingTable

            SELECT  @MaxTranFeeId = MAX(id)
            FROM    @TranFeeIdTable

            UPDATE  OLAPSyncProcessLog
            SET     MoveTranMaxId = @MaxTranId ,
                    MoveTranFeeMaxId = isnull(@MaxTranFeeId,0),
                    Status = 8 ,
                    FinishTime = GETDATE()
            WHERE   SessionId = @SessionId

			DELETE FROM dbo.OLAPSyncTransactionFeeBuffer WHERE SessionId = @SessionId
			DELETE FROM dbo.OLAPSyncTransactionBuffer WHERE SessionId = @SessionId

        END TRY
        BEGIN CATCH
            SELECT  @ErrorMessage = ERROR_MESSAGE();
            SELECT  @ErrorLine = ERROR_LINE();
            ROLLBACK TRANSACTION;
            RETURN;
        END CATCH;

        COMMIT TRANSACTION;
    END;

