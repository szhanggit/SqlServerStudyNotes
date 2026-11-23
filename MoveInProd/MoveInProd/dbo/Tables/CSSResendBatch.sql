CREATE TABLE [dbo].[CSSResendBatch] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [OrderId]          INT           NOT NULL,
    [OrderNumber]      VARCHAR (30)  NOT NULL,
    [BatchNumber]      VARCHAR (30)  NOT NULL,
    [Status]           INT           NOT NULL,
    [CreateOn]         DATETIME      NOT NULL,
    [ExecuteStartTime] DATETIME      NULL,
    [ExecuteEndTime]   DATETIME      NULL,
    [TotalCount]       INT           NOT NULL,
    [SuccessCount]     INT           NULL,
    [FailCount]        INT           NULL,
    [Operater]         NVARCHAR (30) NOT NULL,
    CONSTRAINT [PK_CSSResendBatch_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_CSSResendBatch_BatchNumber]
    ON [dbo].[CSSResendBatch]([BatchNumber] ASC);


GO
CREATE NONCLUSTERED INDEX [Index_CSSResendBatch_CreateOn]
    ON [dbo].[CSSResendBatch]([CreateOn] ASC);

