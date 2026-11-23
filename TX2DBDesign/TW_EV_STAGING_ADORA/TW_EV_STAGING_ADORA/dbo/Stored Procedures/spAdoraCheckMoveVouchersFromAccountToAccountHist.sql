CREATE PROCEDURE [dbo].[spAdoraCheckMoveVouchersFromAccountToAccountHist]      
AS      
BEGIN  

SET NOCOUNT ON

SELECT COUNT(1) AS 'Count' 
FROM ArchiveAccountBuffer aab WITH(NOLOCK)
LEFT JOIN AccountHistory ah WITH(NOLOCK) ON aab.AccountNumber = ah.AccountNumber AND aab.ProgramId = ah.ProgramId
WHERE ah.AccountNumber IS NULL

END