-- =============================================  
-- Author:  Ian M. Bacolod  
-- Create date: 10/14/2021  
-- Description: This stored procedure will sync Voucher table with Adora Account table for records in VoucherSyncFailedLog   
-- =============================================
-- Version History
-- 10/16/2021 Updated by Steven to remove processing by 3000 records per batch
-- =============================================
CREATE PROCEDURE dbo.spSyncVoucherFromAdoraAccount    
AS    
BEGIN  
SET NOCOUNT ON  
 BEGIN TRAN  
 BEGIN TRY  
------------------------------------------------------------  
DECLARE @VoucherSyncFailed TABLE  
(  
 VoucherNumber VARCHAR(50),  
 ProgramCode VARCHAR(20)  
)  
  
DECLARE @VoucherSyncBatchTemp TABLE  
(  
 LogId int,   
  VoucherNumber VARCHAR(50),  
 ProgramCode VARCHAR(20)  
)  
  
insert into @VoucherSyncBatchTemp (LogId, VoucherNumber, ProgramCode)  
select top(1000) Id, VoucherNumber, ProgramCode from VoucherSyncFailedLog with(nolock)  
order by Id   
  
insert into @VoucherSyncFailed (VoucherNumber, ProgramCode)  
select VoucherNumber, ProgramCode from @VoucherSyncBatchTemp  
group by VoucherNumber, ProgramCode  
  
  
  
UPDATE v  
SET v.[Status] = a.[Status]  
 ,v.ActivatedOn = DATEADD(HOUR, 8, a.ActivatedOn)  
 ,v.ExpiryDate = DATEADD(HOUR, 8, a.ActiveTo)   
 ,v.LastTranOn = DATEADD(HOUR, 8, a.LastTranOn)  
 ,v.ConsumeTime = DATEADD(HOUR, 8, a.ConsumeTime)  
 ,v.PublishedOn = DATEADD(HOUR, 8, a.CreatedOn)  
 ,v.BalanceAvailable = a.BalanceAvailable  
 ,v.BalanceFrozen = a.BalanceFrozen  
 ,v.ConsumeMerchantCode = a.ConsumeMerchantCode  
 ,v.ConsumeShopCode = a.ConsumeShopCode  
 ,v.ConsumeTerminalSSN = a.ConsumeTerminalSSN  
FROM Voucher v WITH(NOLOCK)  
JOIN TW_EV_UAT_ADORA.dbo.Program p WITH(NOLOCK) ON p.ExternalId = v.ProgramId  
JOIN TW_EV_UAT_ADORA.dbo.Account a WITH(NOLOCK) ON a.AccountNumber = v.VoucherNumber AND a.ProgramId = p.Id  
JOIN @VoucherSyncFailed t ON t.VoucherNumber = a.AccountNumber AND t.ProgramCode = p.IdentityCode  
  
  
  
 INSERT INTO VoucherSyncFailedLogArchive (ProgramCode  
  ,VoucherNumber  
  ,BalanceAvailable  
  ,BalanceFrozen  
  ,[Status]  
  ,PublishedOn  
  ,ActivatedOn  
  ,ExpiryDate  
  ,ConsumeTime  
  ,ConsumeMerchantCode  
  ,ConsumeShopCode  
  ,ConsumeTerminalSSN  
  ,LastTranOn  
  ,CreatedDate  
  ,SessionId  
  ,ArchiveDate)  
 SELECT v.ProgramCode  
  ,v.VoucherNumber  
  ,BalanceAvailable  
  ,BalanceFrozen  
  ,[Status]  
  ,PublishedOn  
  ,ActivatedOn  
  ,ExpiryDate  
  ,ConsumeTime  
  ,ConsumeMerchantCode  
  ,ConsumeShopCode  
  ,ConsumeTerminalSSN  
  ,LastTranOn  
  ,CreatedDate  
  ,v.SessionId  
  ,GETDATE()  
 FROM VoucherSyncFailedLog v WITH(NOLOCK)   
 JOIN @VoucherSyncBatchTemp t ON t.LogId = v.Id AND t.VoucherNumber = v.VoucherNumber AND t.ProgramCode = v.ProgramCode  
  
  
 DELETE v  
 FROM VoucherSyncFailedLog v  
 JOIN @VoucherSyncBatchTemp t ON t.LogId = v.Id AND t.VoucherNumber = v.VoucherNumber AND t.ProgramCode = v.ProgramCode  
  
  
COMMIT TRANSACTION;   
------------------------------------------------------------  
 END TRY  
 BEGIN CATCH  
  IF @@TRANCOUNT > 0  
   ROLLBACK TRANSACTION;  
 END CATCH;  
END    