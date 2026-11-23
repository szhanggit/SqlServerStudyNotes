CREATE TABLE [dbo].[CSSResendBatchVoucher] (
    [Id]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [BatchId]        INT           NOT NULL,
    [OrderNumber]    VARCHAR (30)  NOT NULL,
    [VoucherId]      BIGINT        NULL,
    [VoucherNumber]  VARCHAR (30)  NULL,
    [EmailTaskId]    INT           NULL,
    [SlmsTaskId]     INT           NULL,
    [Email]          VARCHAR (50)  NULL,
    [Mobile]         VARCHAR (20)  NULL,
    [NewEmail]       VARCHAR (50)  NULL,
    [NewMobile]      VARCHAR (20)  NULL,
    [ActionType]     CHAR (3)      NOT NULL,
    [ResponeCode]    VARCHAR (10)  NULL,
    [ResponeMessage] NVARCHAR (50) NULL,
    [Comment]        NVARCHAR (30) NULL,
    CONSTRAINT [PK_CSSResendBatchVoucher_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_CSSResendBatchVoucher_BatchId]
    ON [dbo].[CSSResendBatchVoucher]([BatchId] ASC);

