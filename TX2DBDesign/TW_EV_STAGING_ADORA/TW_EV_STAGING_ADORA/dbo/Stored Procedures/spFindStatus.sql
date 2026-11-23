-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/5/28
-- Description:	Find Transactions
-- =============================================
CREATE PROCEDURE spFindStatus
	-- Add the parameters for the stored procedure here
	@AcountNumber		varchar(50)
	,@ProgramCode		varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [StartTime] AS [Date]
			,[Status]
	FROM [dbo].[AccountStatusHistory] ASH
	INNER JOIN [dbo].[Program] P ON ASH.ProgramId = P.Id AND P.IdentityCode = @ProgramCode
	WHERE ASH.AccountNumber = @AcountNumber
END
