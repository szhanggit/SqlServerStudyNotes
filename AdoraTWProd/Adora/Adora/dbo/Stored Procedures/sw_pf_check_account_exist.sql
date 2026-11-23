-- =============================================
-- Author:      Yun Lian
-- Create date: 2015-05-07
-- Description: check if account number exist in 20
-- =============================================
CREATE PROCEDURE [dbo].[sw_pf_check_account_exist]
    @accountNumber nvarchar(200),
    @retCode int output
AS
BEGIN
    if exists (select [AccountNumber] from [dbo].[Account] where [AccountNumber] = @accountNumber)
        
        set @retCode = 1
    else if exists (select [AccountNumber] from [dbo].[AccountHistory] where [AccountNumber] = @accountNumber)
        set @retCode = 1
    else 

        set @retCode = 0
END
