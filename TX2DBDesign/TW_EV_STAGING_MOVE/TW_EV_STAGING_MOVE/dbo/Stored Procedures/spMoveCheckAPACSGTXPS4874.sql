CREATE PROCEDURE [dbo].[spMoveCheckAPACSGTXPS4874]      
AS      
BEGIN  

SET NOCOUNT ON;

WITH sTable(VoucherNumber, ProgramId, MoveStatus, AdoraStatus) 
AS (SELECT v.VoucherNumber, v.ProgramId, v.[Status] AS MoveStatus, a.[Status] AS AdoraStatus 
	FROM Voucher v WITH(NOLOCK)
	INNER JOIN TW_EV_UAT_ADORA.dbo.Program p WITH(NOLOCK) ON v.ProgramId = p.ExternalId
	INNER JOIN TW_EV_UAT_ADORA.dbo.Account a WITH(NOLOCK) ON v.VoucherNumber = a.AccountNumber AND a.ProgramId = p.Id
	WHERE a.[Status] = 256 
	AND v.[Status] = 2)

SELECT TOP 1 t.* 
FROM sTable t WITH(NOLOCK)
LEFT JOIN TW_EV_UAT_ADORA.dbo.AccountToSync a WITH(NOLOCK) ON t.VoucherNumber = a.AccountNumber AND t.ProgramId = a.ProgramId
WHERE a.AccountNumber IS NULL

END