
CREATE PROCEDURE [dbo].[spUndoHistoryMultiAccountsTransaction]  
@MultiAccountsTransactionId BIGINT
AS  
BEGIN
SET NOCOUNT ON
	BEGIN TRAN
	BEGIN TRY
------------------------------------------------------------
		SET IDENTITY_INSERT [dbo].MultiAccountsTransaction ON

		INSERT INTO MultiAccountsTransaction (Id
			,ProgramCode
			,MerchantCode
			,TerminalSSN
			,TranUtcDate
			,TranUtcDateTimeL
			,TranUtcDateTime
			,TranLocalDate
			,TranLocalDateTime
			,TranTerminalDateTime
			,ShopCode
			,TerminalCode
			,ShiftCode
			,BusinessDay
			,TranType
			,[Status]
			,ResponseCode
			,NodeNum
			,CallerIP
			,Channel
			,[Parameters]
			,ModifyVersion
			,Rsv1
			,Rsv2
			,Rsv3
			,ShiftClearingId
			,DailyClearingId)
		SELECT t.Id
			,t.ProgramCode
			,t.MerchantCode
			,t.TerminalSSN
			,t.TranUtcDate
			,t.TranUtcDateTimeL
			,t.TranUtcDateTime
			,t.TranLocalDate
			,t.TranLocalDateTime
			,t.TranTerminalDateTime
			,t.ShopCode
			,t.TerminalCode
			,t.ShiftCode
			,t.BusinessDay
			,t.TranType
			,t.[Status]
			,t.ResponseCode
			,t.NodeNum
			,t.CallerIP
			,t.Channel
			,t.[Parameters]
			,t.ModifyVersion
			,t.Rsv1
			,t.Rsv2
			,t.Rsv3
			,t.ShiftClearingId
			,t.DailyClearingId
		FROM MultiAccountsTransaction_History t WITH(NOLOCK) 
		INNER JOIN MultiAccountsTransactionDetail_History th WITH(NOLOCK) ON th.MultiAccountsTransactionId = t.Id
		WHERE t.DailyClearingId IS NULL 
		AND t.Id = @MultiAccountsTransactionId
		ORDER BY t.TranLocalDateTime DESC

		SET IDENTITY_INSERT [dbo].MultiAccountsTransaction OFF





		SET IDENTITY_INSERT [dbo].MultiAccountsTransactionDetail ON

		INSERT INTO MultiAccountsTransactionDetail (Id
			,MultiAccountsTransactionId
			,AccountNumber
			,TranAmount
			,TranCode
			,TranCodeRef)
		SELECT th.Id
			,th.MultiAccountsTransactionId
			,th.AccountNumber
			,th.TranAmount
			,th.TranCode
			,th.TranCodeRef
		FROM MultiAccountsTransaction_History t WITH(NOLOCK) 
		INNER JOIN MultiAccountsTransactionDetail_History th WITH(NOLOCK) ON th.MultiAccountsTransactionId = t.Id
		WHERE t.DailyClearingId IS NULL 
		AND t.Id = @MultiAccountsTransactionId

		SET IDENTITY_INSERT [dbo].MultiAccountsTransactionDetail OFF



		SET IDENTITY_INSERT [dbo].FailureReversalDetail ON

		insert into FailureReversalDetail (Id, MultiAccountsTransactionId, TerminalSSNRef)
		select Id, MultiAccountsTransactionId, TerminalSSNRef from FailureReversalDetail_History with(nolock) 
		where MultiAccountsTransactionId = @MultiAccountsTransactionId

		SET IDENTITY_INSERT [dbo].FailureReversalDetail OFF


		-- Delete from History tables
		DELETE FROM MultiAccountsTransactionDetail_History
		WHERE MultiAccountsTransactionId = @MultiAccountsTransactionId

		DELETE FROM MultiAccountsTransaction_History
		WHERE Id = @MultiAccountsTransactionId

		DELETE FROM FailureReversalDetail
		WHERE Id = @MultiAccountsTransactionId

		COMMIT TRANSACTION;	
------------------------------------------------------------
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		select ERROR_MESSAGE();	
	END CATCH;
END		



