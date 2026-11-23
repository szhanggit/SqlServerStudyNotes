

CREATE PROCEDURE [dbo].[spArchiveTransactionArchiveData_TW]
    @ArchiveTaskLogId BIGINT
AS
    BEGIN
	-- ******************************************************
	-- Change archive database name for different environment
	-- Current: TW_EV_DBS_MOVEARCH
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
           ) <> 3
            RETURN
	
        BEGIN TRAN
        BEGIN TRY
            IF EXISTS ( SELECT  1
                        FROM    [TW_EV_UAT_MOVEARCH].[dbo].[TransactionArchiveReceiveBuffer] )
                BEGIN
                    INSERT  INTO [TW_EV_UAT_MOVEARCH].[dbo].[TransactionArchive]
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
                            FROM    [TW_EV_UAT_MOVEARCH].[dbo].[TransactionArchiveReceiveBuffer]
			
                    INSERT  INTO [TW_EV_UAT_MOVEARCH].[dbo].[TransactionFeeArchive]
                            ( [Id] ,
                              [TransactionId] ,
                              [ServiceFeeId] ,
                              [TranFee]
			                )
                            SELECT  [Id] ,
                                    [TransactionId] ,
                                    [ServiceFeeId] ,
                                    [TranFee]
                            FROM    [TW_EV_UAT_MOVEARCH].[dbo].[TransactionFeeArchiveReceiveBuffer]
                END
			
            UPDATE  [dbo].[ArchiveTaskLog]
            SET     [Status] = 4
            WHERE   Id = @ArchiveTaskLogId
			
            UPDATE  t2
            SET     LastExecuteStatus = 4
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

