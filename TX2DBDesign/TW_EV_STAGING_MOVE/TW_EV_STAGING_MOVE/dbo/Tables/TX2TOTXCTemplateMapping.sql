CREATE TABLE [dbo].[TX2TOTXCTemplateMapping] (
    [Id]             BIGINT IDENTITY (1, 1) NOT NULL,
    [TXConnectionId] INT    NOT NULL,
    [ExternalTXCId]  INT    NULL,
    [TenantId]       INT    NOT NULL,
    [TXTemplateType] INT    NOT NULL,
    CONSTRAINT [PK_TX2TOTXCTemplateMapping_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

