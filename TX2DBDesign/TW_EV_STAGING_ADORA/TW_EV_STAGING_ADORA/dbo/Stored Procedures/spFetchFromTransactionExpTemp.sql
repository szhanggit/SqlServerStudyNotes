
CREATE PROCEDURE [dbo].[spFetchFromTransactionExpTemp]
	@SessionId			VARCHAR(100)
	,@RowCount			INT
	,@ErrorMessage		VARCHAR(4000)	OUTPUT
	,@ErrorLine			INT				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @UpdatedTransaction table (
			[AccountNumber] [varchar](50) NOT NULL,
			[ProgramCode] [varchar](20) NOT NULL,
			[MerchantCode] [varchar](50) NOT NULL,
			[HostSSN] [varchar](12) NULL,
			[TerminalSSN] [varchar](50) NULL,
			[TranUtcDate] [int] NULL,
			[TranUtcDateTimeL] [bigint] NULL,
			[TranUtcDateTime] [datetime] NULL,
			[TranLocalDate] [int] NULL,
			[TranLocalDateTime] [datetime] NULL,
			[TranTerminalDateTime] [datetime] NULL,
			[SettleDate] [int] NULL,
			[TranRealDateTime] [datetime] NULL,
			[ShopCode] [varchar](50) NULL,
			[TerminalCode] [varchar](50) NULL,
			[TranType] [smallint] NULL,
			[Status] [tinyint] NULL,
			[TranAmount] [int] NULL,
			[RefundedAmount] [int] NULL,
			[ResponseCode] [varchar](5) NULL,
			[IsCleared] [bit] NULL,
			[NodeNum] [int] NULL,
			[CallerIP] [varchar](50) NULL,
			[Channel] [varchar](20) NULL,
			[Parameters] [nvarchar](4000) NULL,
			[TranCode] [varchar](50) NOT NULL,
			[TranCodeRef] [varchar](50) NULL,
			[TranGUID] [uniqueidentifier] NULL,
			[TranGUIDRef] [uniqueidentifier] NULL,
			[ModifyVersion] [int] NULL,
			[BalanceAvailable] [int] NULL,
			[BalanceFrozen] [int] NULL,
			[Checksum] [varchar](50) NULL,
			[SecurityKeyId] [int] NULL,
			[Rsv1] [nvarchar](255) NULL,
			[Rsv2] [nvarchar](255) NULL,
			[Rsv3] [nvarchar](255) NULL,
			[ShiftCode] [varchar](50) NULL,
			[BusinessDay] [int] NULL,
			[MultiAccountsTransactionId] [bigint] NULL,
			SessionId varchar(100) null		
		);
	
	BEGIN TRAN
	BEGIN TRY

		

		UPDATE TOP(@RowCount) TransactionExpTemp
		SET SessionId = @SessionId OUTPUT 
			Inserted.[AccountNumber],
			Inserted.[ProgramCode],
			Inserted.[MerchantCode],
			Inserted.[HostSSN],
			Inserted.[TerminalSSN],
			Inserted.[TranUtcDate],
			Inserted.[TranUtcDateTimeL],
			Inserted.[TranUtcDateTime],
			Inserted.[TranLocalDate],
			Inserted.[TranLocalDateTime],
			Inserted.[TranTerminalDateTime],
			Inserted.[SettleDate],
			Inserted.[TranRealDateTime],
			Inserted.[ShopCode],
			Inserted.[TerminalCode],
			Inserted.[TranType],
			Inserted.[Status],
			Inserted.[TranAmount],
			Inserted.[RefundedAmount],
			Inserted.[ResponseCode],
			Inserted.[IsCleared],
			Inserted.[NodeNum],
			Inserted.[CallerIP],
			Inserted.[Channel],
			Inserted.[Parameters],
			Inserted.[TranCode],
			Inserted.[TranCodeRef],
			Inserted.[TranGUID],
			Inserted.[TranGUIDRef],
			Inserted.[ModifyVersion],
			Inserted.[BalanceAvailable],
			Inserted.[BalanceFrozen],
			Inserted.[Checksum],
			Inserted.[SecurityKeyId],
			Inserted.[Rsv1],
			Inserted.[Rsv2],
			Inserted.[Rsv3],
			Inserted.[ShiftCode],
			Inserted.[BusinessDay],
			Inserted.[MultiAccountsTransactionId],
			Inserted.SessionId					
		into @UpdatedTransaction
		where SessionId is null;

		select * from @UpdatedTransaction;



	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE()
		SELECT @ErrorLine = ERROR_LINE()

		IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE name = '#tmp_hostssn' )
			DROP TABLE #tmp_hostssn

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

			declare @errorSeverity int
					,@errorState int

			select @errorMessage = ERROR_MESSAGE()	
					,@errorSeverity = ERROR_SEVERITY()
					,@errorState = ERROR_STATE()	

			/*抛出一个异常*/
			raiserror (@errorMessage,@errorSeverity,@errorState)
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END

