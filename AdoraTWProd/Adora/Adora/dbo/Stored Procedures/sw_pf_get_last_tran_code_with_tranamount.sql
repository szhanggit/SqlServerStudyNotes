-- =============================================
-- Author:		Yun Lian
-- Create date: 2015-05-15
-- Description:	Get Last Tran Code
-- =============================================
CREATE PROCEDURE [dbo].[sw_pf_get_last_tran_code_with_tranamount]
	@AccountNumber varchar(50),
	@ProgramCode VARCHAR(20),
	@TranAmount int
AS
BEGIN
	 if exists (select  [TranCode] from [dbo].[Transaction]
	 where [AccountNumber] = @AccountNumber AND ProgramCode=@ProgramCode and TranType = 101 and responsecode = '0000' AND TranAmount=@TranAmount AND Status=1)
		 begin
			select  top 1  [TranCode] from [dbo].[Transaction]
				where [AccountNumber] = @AccountNumber and TranType = 101 and responsecode = '0000' AND TranAmount=@TranAmount AND Status=1
				order by [TranUtcDateTimeL] desc
		 end
	else
		begin
			select  top 1  [TranCode] from  [dbo].[TransactionHistory]
				where [AccountNumber] = @AccountNumber AND ProgramCode=@ProgramCode  and TranType = 101 and responsecode = '0000' AND TranAmount=@TranAmount AND Status=1
				order by [TranUtcDateTimeL] desc
		end

END


SELECT TOP 100 * FROM dbo.[Transaction] WHERE TranType = 101