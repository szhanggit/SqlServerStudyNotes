CREATE TABLE [dbo].[PreIssuedCampaignAccountsBuffer] (
    [Id]            BIGINT           IDENTITY (1, 1) NOT NULL,
    [AccountNumber] VARCHAR (50)     NOT NULL,
    [ProgramId]     INT              NOT NULL,
    [SessionId]     UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_PreIssuedCampaignAccountsBuffer_Id] PRIMARY KEY CLUSTERED ([Id] DESC)
);


GO
CREATE NONCLUSTERED INDEX [Index_Self_RequestId]
    ON [dbo].[PreIssuedCampaignAccountsBuffer]([SessionId] ASC);

