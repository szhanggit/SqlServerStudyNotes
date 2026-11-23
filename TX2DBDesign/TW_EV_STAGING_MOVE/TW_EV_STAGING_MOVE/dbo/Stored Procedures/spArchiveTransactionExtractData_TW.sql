


CREATE PROCEDURE [dbo].[spArchiveTransactionExtractData_TW]
    @ArchiveTaskLogId BIGINT ,
    @ArchiveStep BIGINT
AS
    BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
			SET NOCOUNT ON;
	
		--ArchiveTaskLog Status：
		--1.Initialized
		--2.Extracted
		--3.Synchronized
		--4.Archived
		--5.Finished
	
        IF ( SELECT [Status]
             FROM   ArchiveTaskLog
             WHERE  Id = @ArchiveTaskLogId
           ) <> 1
            RETURN
	
        DECLARE @DataCount INT
        DECLARE @StartId BIGINT
        DECLARE @TempEndId BIGINT
		DECLARE @EndId BIGINT
		DECLARE @TwoYearAgo INT
		DECLARE @MAXSETTLEDATE INT
		DECLARE @SQL VARCHAR(4000)
				
		--Get the date of two years ago. eg. 20170719
		SELECT @TwoYearAgo = convert(INT, convert(VARCHAR(50), DATEADD(YEAR,-2,GETDATE()), 112))
		
		--Get the minimum Id.
		SELECT @StartId = MIN(Id) FROM [Transaction] WITH(NOLOCK)

		--Calculate the 
		SET @TempEndId = @StartId + @ArchiveStep

		--Get the real end id.
		SELECT @EndId = MAX(Id) FROM [Transaction] WITH(NOLOCK) WHERE Id <= @TempEndId
		
		SELECT @MAXSETTLEDATE = SettleDate FROM [Transaction] WITH(NOLOCK) WHERE ID = @EndId
		
        BEGIN TRAN
        BEGIN TRY

			--if no data, the end. 
			IF(@MAXSETTLEDATE >= @TwoYearAgo OR ISNULL(@EndId,0) < @StartId) 
				BEGIN
					UPDATE  [dbo].[ArchiveTaskLog]
					SET     [Status] = 5 ,
							[DataCount] = 0 ,
							ArchivedDataStartId = @StartId,
							ArchivedDataEndId = ISNULL(@EndId,0),
							ExecuteEndTime = GETDATE()
					WHERE   Id = @ArchiveTaskLogId
		
					UPDATE  t2
					SET     LastExecuteStatus = 5 ,
                            LastExecuteEndTime = GETDATE() ,
                            LastExecuteDataCount = @DataCount ,
                            ArchivedDataEndId =ISNULL(@EndId,0)
					FROM    dbo.ArchiveTaskLog AS t1
							JOIN dbo.ArchiveTask AS t2 ON t2.Id = t1.TaskId
					WHERE   t1.id = @ArchiveTaskLogId
				END
			ELSE
				BEGIN
					IF NOT EXISTS ( SELECT 1 FROM dbo.TransactionArchiveSendBuffer)
						BEGIN
								select @sql = 
								'INSERT  INTO [dbo].[TransactionArchiveSendBuffer]
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
										SELECT  T1.[Id] ,
												[AccountNumber] ,
												T1.[ProgramCode] ,
												[MerchantCode] ,
												[ShopCode] ,
												[TranType] ,
												[TranLocalDate] ,
												[TranLocalDateTime] ,
												[SettleDate] ,
												[TranRealDateTime] ,
												T1.[Status] ,
												[TranAmount] ,
												[RefundedAmount] ,
												[ResponseCode] ,
												[Channel] ,
												[TranCode] ,
												[TranCodeRef] ,
												T1.[BalanceAvailable] ,
												T1.[BalanceFrozen] ,
												[MerchantId] ,
												[ShopId] ,
												[ClientQuotationProductId] ,
												T1.[ProductId] ,
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
										FROM    [dbo].[Transaction] AS T1 WITH ( NOLOCK )
										WHERE T1.Id BETWEEN ' + cast(@StartId as varchar(20)) +  ' AND ' + cast(@EndId as varchar(20))
							
							EXECUTE (@sql)

							SET @DataCount = @@rowcount

							INSERT  INTO [dbo].[TransactionFeeArchiveSendBuffer]
									( [Id] ,
									  [TransactionId] ,
									  [ServiceFeeId] ,
									  [TranFee]
									)
									SELECT  T1.[Id] ,
											T1.[TransactionId] ,
											T1.[ServiceFeeId] ,
											T1.[TranFee]
									FROM    [dbo].TransactionFee AS T1 WITH(NOLOCK)
											INNER JOIN [TransactionArchiveSendBuffer]
											AS T2 ON T1.TransactionId = T2.Id
						END
		
					UPDATE  [dbo].[ArchiveTaskLog]
					SET     [Status] = 2 ,
							[DataCount] = @DataCount ,
							ArchivedDataStartId = @StartId,
							ArchivedDataEndId = @EndId,
							ExecuteEndTime = GETDATE() 
					WHERE   Id = @ArchiveTaskLogId
		
					UPDATE  t2
					SET     LastExecuteStatus = 2
					FROM    dbo.ArchiveTaskLog AS t1
							JOIN dbo.ArchiveTask AS t2 ON t2.Id = t1.TaskId
					WHERE   t1.id = @ArchiveTaskLogId
				END
            COMMIT TRAN;
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN; 
		
            UPDATE  [dbo].[ArchiveTaskLog]
            SET     [Comment] = ERROR_MESSAGE()
            WHERE   Id = @ArchiveTaskLogId
        END CATCH
    END

