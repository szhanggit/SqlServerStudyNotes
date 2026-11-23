CREATE TABLE [dbo].[DistributionSLMSMessageStatus] (
    [Id]                        BIGINT         IDENTITY (1, 1) NOT NULL,
    [ExternalId]                BIGINT         NULL,
    [DistributionTaskMessageId] BIGINT         NULL,
    [SendStatus]                INT            NULL,
    [OriginalStatus]            NVARCHAR (50)  NULL,
    [Description]               NVARCHAR (MAX) NOT NULL,
    [CreatedTime]               DATETIME       NULL,
    [OriginalTime]              DATETIME       NULL,
    CONSTRAINT [PK_DistributionSLMSMessageStatus] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_DistributionSLMSMessageStatus_DistributionTaskMessageId]
    ON [dbo].[DistributionSLMSMessageStatus]([DistributionTaskMessageId] ASC);

