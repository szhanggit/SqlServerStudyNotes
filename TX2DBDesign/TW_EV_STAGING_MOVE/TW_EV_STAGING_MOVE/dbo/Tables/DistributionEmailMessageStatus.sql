CREATE TABLE [dbo].[DistributionEmailMessageStatus] (
    [Id]                        BIGINT         IDENTITY (1, 1) NOT NULL,
    [ExternalId]                BIGINT         NULL,
    [DistributionTaskMessageId] BIGINT         NULL,
    [SendStatus]                INT            NULL,
    [OriginalStatus]            NVARCHAR (50)  NULL,
    [Description]               NVARCHAR (MAX) NOT NULL,
    [CreatedTime]               DATETIME       NULL,
    [OriginalTime]              DATETIME       NULL,
    CONSTRAINT [PK_DistributionEmailMessageStatus] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_DistributionEmailMessageStatus_DistributionTaskMessageId]
    ON [dbo].[DistributionEmailMessageStatus]([DistributionTaskMessageId] ASC);

