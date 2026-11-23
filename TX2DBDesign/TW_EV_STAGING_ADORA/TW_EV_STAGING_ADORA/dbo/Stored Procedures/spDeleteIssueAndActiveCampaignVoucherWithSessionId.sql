
CREATE PROCEDURE spDeleteIssueAndActiveCampaignVoucherWithSessionId
@SessionId varchar(50)
AS
BEGIN
Delete IssueAndActiveCampaignVoucherBuffer Where [SessionId]=@SessionId
END
