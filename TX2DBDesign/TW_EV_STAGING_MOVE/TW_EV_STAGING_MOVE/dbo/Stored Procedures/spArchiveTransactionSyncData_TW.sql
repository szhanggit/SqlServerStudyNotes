


CREATE PROCEDURE [dbo].[spArchiveTransactionSyncData_TW]
    @ArchiveTaskLogId BIGINT
AS
    BEGIN
	-- ******************************************************
	-- Change archive database name for different environment
	-- Current: u_ev_mo
	-- ******************************************************

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

	--ArchiveTaskLog Status：
	--1.Initialized
	--2.Extracted
	--3.Synchronized
	--4.Archived
	--5.Finished
	
        IF ( SELECT Status
             FROM   ArchiveTaskLog
             WHERE  Id = @ArchiveTaskLogId
           ) <> 2
            RETURN
	
        BEGIN TRAN
        BEGIN TRY
            IF EXISTS ( SELECT  1
                        FROM    [dbo].[TransactionArchiveSendBuffer] )
                BEGIN
                    INSERT  INTO [TW_EV_UAT_MOVEARCH].[dbo].[TransactionArchiveReceiveBuffer]
                            ( [Id] ,
                              [AccountNumber] ,
                              [ProgramCode] ,
                              [MerchantCode] ,
                              [ShopCode] ,
                              [TranType] ,
                              [TranLocalDate] ,
                              [TranLocalDateTime] ,
                              [SettleDate] ,
                              [TranRealDateTime] ,
                              [Status] ,
                              [TranAmount] ,
                              [RefundedAmount] ,
                              [ResponseCode] ,
                              [Channel] ,
                              [TranCode] ,
                              [TranCodeRef] ,
                              [BalanceAvailable] ,
                              [BalanceFrozen] ,
                              [MerchantId] ,
                              [ShopId] ,
                              [ClientQuotationProductId] ,
                              [ProductId] ,
                              [OrderId] ,
                              [InvoiceToBeRequestedId] ,
                              [ClientQuotationPricingId] ,
                              [ReimbursementSchemeId] ,
                              [ReimbursementLineId] ,
                              [InvoiceValue] ,
                              [ReimbursementValue] ,
                              [Bill] ,
                              [ServiceFee] ,
                              [IIV] ,
                              [IV] ,
                              [Discount] ,
                              [IRV] ,
                              [RV] ,
                              [NWR] ,
                              [NWA] ,
                              [IEV] ,
                              [EV] ,
                              [NoShowPrice] ,
                              [NoShowCost] ,
                              [CostMarketing] ,
                              [CostEmployeeWelfare] ,
                              [CostTest] ,
                              [Rsv1] ,
                              [Rsv2] ,
                              [Rsv3] ,
                              [TerminalSSN] ,
                              [ShiftCode] ,
                              [BusinessDay] ,
                              [TerminalCode]
			                )
                            SELECT  [Id] ,
                                    [AccountNumber] ,
                                    [ProgramCode] ,
                                    [MerchantCode] ,
                                    [ShopCode] ,
                                    [TranType] ,
                                    [TranLocalDate] ,
                                    [TranLocalDateTime] ,
                                    [SettleDate] ,
                                    [TranRealDateTime] ,
                                    [Status] ,
                                    [TranAmount] ,
                                    [RefundedAmount] ,
                                    [ResponseCode] ,
                                    [Channel] ,
                                    [TranCode] ,
                                    [TranCodeRef] ,
                                    [BalanceAvailable] ,
                                    [BalanceFrozen] ,
                                    [MerchantId] ,
                                    [ShopId] ,
                                    [ClientQuotationProductId] ,
                                    [ProductId] ,
                                    [OrderId] ,
                                    [InvoiceToBeRequestedId] ,
                                    [ClientQuotationPricingId] ,
                                    [ReimbursementSchemeId] ,
                                    [ReimbursementLineId] ,
                                    [InvoiceValue] ,
                                    [ReimbursementValue] ,
                                    [Bill] ,
                                    [ServiceFee] ,
                                    [IIV] ,
                                    [IV] ,
                                    [Discount] ,
                                    [IRV] ,
                                    [RV] ,
                                    [NWR] ,
                                    [NWA] ,
                                    [IEV] ,
                                    [EV] ,
                                    [NoShowPrice] ,
                                    [NoShowCost] ,
                                    [CostMarketing] ,
                                    [CostEmployeeWelfare] ,
                                    [CostTest] ,
                                    [Rsv1] ,
                                    [Rsv2] ,
                                    [Rsv3] ,
                                    [TerminalSSN] ,
                                    [ShiftCode] ,
                                    [BusinessDay] ,
                                    [TerminalCode]
                            FROM    [dbo].[TransactionArchiveSendBuffer]
                            WHERE   ISNULL(Deleted, 0) = 0

                    INSERT  INTO [TW_EV_UAT_MOVEARCH].[dbo].[TransactionFeeArchiveReceiveBuffer]
                            ( [Id] ,
                              [TransactionId] ,
                              [ServiceFeeId] ,
                              [TranFee]
			                )
                            SELECT  t1.[Id] ,
                                    t1.[TransactionId] ,
                                    t1.[ServiceFeeId] ,
                                    t1.[TranFee]
                            FROM    [dbo].[TransactionFeeArchiveSendBuffer] AS t1
                                    JOIN dbo.TransactionArchiveSendBuffer AS t2 ON t1.TransactionId = t2.Id
                            WHERE   ISNULL(t2.Deleted, 0) = 0
                END
            UPDATE  [dbo].[ArchiveTaskLog]
            SET     [Status] = 3
            WHERE   Id = @ArchiveTaskLogId
			
            UPDATE  t2
            SET     LastExecuteStatus = 3
            FROM    dbo.ArchiveTaskLog AS t1
                    JOIN dbo.ArchiveTask AS t2 ON t2.Id = t1.TaskId
            WHERE   t1.id = @ArchiveTaskLogId
			
                   
              
            COMMIT TRAN;
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN; 
		
            UPDATE  [dbo].[ArchiveTaskLog]
            SET     [Comment] = ERROR_MESSAGE()
            WHERE   Id = @ArchiveTaskLogId
        END CATCH
    END

