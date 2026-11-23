

CREATE PROCEDURE [dbo].[spSetIssueAndActiveCampaignVoucherWithSessionId]
@SessionId varchar(50),
@Count int
AS
BEGIN
Update Top (@Count) IssueAndActiveCampaignVoucherBuffer  Set [SessionId]=@SessionId Where SessionId is null

update a set ActivatedOn = ia.IssueDate, ActiveFrom = ia.IssueDate, ExpiredOn = a.ActiveTo
from IssueAndActiveCampaignVoucherBuffer ia with(nolock)
join Account a on a.AccountNumber = ia.AccountNumber
where ia.SessionId = @SessionId
END
