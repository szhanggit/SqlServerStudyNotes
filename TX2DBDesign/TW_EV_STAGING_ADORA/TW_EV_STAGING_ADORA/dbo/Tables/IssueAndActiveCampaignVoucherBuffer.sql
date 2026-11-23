CREATE TABLE [dbo].[IssueAndActiveCampaignVoucherBuffer] (
    [AccountNumber]            VARCHAR (50) NOT NULL,
    [ProgramCode]              VARCHAR (50) NOT NULL,
    [MasterAccountNumber]      VARCHAR (50) NULL,
    [MasterAccountProgramCode] VARCHAR (50) NULL,
    [IssueDate]                DATETIME     NOT NULL,
    [IsMaster]                 BIT          NOT NULL,
    [SessionId]                VARCHAR (50) NULL
);

