-- =============================================
-- Author:		Yun Lian
-- Create date: 2015-05-15
-- Description:	Get Last Tran Code
-- =============================================
CREATE PROCEDURE [dbo].[sw_pf_get_last_tran_code]
	@AccountNumber varchar(50)
AS
BEGIN
	 if exists (select  [TranCode] from [dbo].[Transaction]
	 where [AccountNumber] = @AccountNumber and TranType = 101 and responsecode = '0000')
		 begin
			select  top 1  [TranCode] from [dbo].[Transaction]
				where [AccountNumber] = @AccountNumber and TranType = 101 and responsecode = '0000'
				order by [TranUtcDateTimeL] desc
		 end
	else
		begin
			select  top 1  [TranCode] from  [dbo].[TransactionHistory]
				where [AccountNumber] = @AccountNumber and TranType = 101 and responsecode = '0000'
				order by [TranUtcDateTimeL] desc
		end

END
