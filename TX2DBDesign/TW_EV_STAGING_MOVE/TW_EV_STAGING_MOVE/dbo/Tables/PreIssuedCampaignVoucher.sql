CREATE TABLE [dbo].[PreIssuedCampaignVoucher] (
    [VoucherId]         BIGINT          NOT NULL,
    [RequestId]         VARCHAR (50)    NOT NULL,
    [OrderNumber]       VARCHAR (50)    NOT NULL,
    [ProductCode]       VARCHAR (50)    NOT NULL,
    [ClientOrderNumber] VARCHAR (50)    NOT NULL,
    [RecipientEmail]    VARCHAR (100)   NULL,
    [RecipientMemo]     NVARCHAR (1000) NULL,
    [RecipientSms]      VARCHAR (50)    NULL,
    [RecipientName]     NVARCHAR (100)  NULL,
    [CreatedOn]         DATETIME        NOT NULL,
    [ProcessStatus]     INT             NOT NULL,
    [Id]                INT             IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_PreIssuedCampaignVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Index_PreIssuedCampaignVoucher_VoucherId]
    ON [dbo].[PreIssuedCampaignVoucher]([VoucherId] ASC);

