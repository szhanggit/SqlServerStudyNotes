-- =============================================
-- Author:      Yun Lian
-- Create date: 2015-05-07
-- Description: check if account number exist in 20
-- =============================================
CREATE PROCEDURE [dbo].[sw_pf_get_account_info]
    @programCode VARCHAR(20),
    @accountNumber VARCHAR(50)
AS
BEGIN
    SELECT ValueType
	FROM dbo.Account t1 JOIN dbo.Program t2 ON t1.ProgramId = t2.Id
	WHERE AccountNumber = @accountNumber AND t2.IdentityCode = @programCode

	IF(@@ROWCOUNT>0)
	  RETURN
      
	SELECT ValueType
	FROM dbo.AccountHistory t1 JOIN dbo.Program t2 ON t1.ProgramId = t2.Id
	WHERE AccountNumber = @accountNumber AND t2.IdentityCode = @programCode

END
