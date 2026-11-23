
CREATE PROCEDURE spFetchIssueAndActiveCampaignVoucherInfo
@SessionId varchar(50),
@Count int
AS
BEGIN
select top (@Count)
cvb.AccountNumber,
cvb.ProgramCode,
cvb.MasterAccountNumber,
cvb.MasterAccountProgramCode,
cvb.IssueDate,
cvb.IsMaster,
a.BalanceInitialized,
a.ActiveTo
from IssueAndActiveCampaignVoucherBuffer cvb with(nolock)
join Program pr with(nolock) on pr.IdentityCode = cvb.ProgramCode
join Account a with(nolock) on a.AccountNumber = cvb.AccountNumber and a.ProgramId = pr.Id
where cvb.SessionId = @SessionId
END
