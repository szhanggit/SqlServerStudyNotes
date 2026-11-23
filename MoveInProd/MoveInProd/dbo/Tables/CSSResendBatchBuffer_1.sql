CREATE TABLE [dbo].[CSSResendBatchBuffer] (
    [BatchNumber] VARCHAR (30)  NOT NULL,
    [OrderId]     INT           NOT NULL,
    [Email]       VARCHAR (50)  NULL,
    [Mobile]      VARCHAR (20)  NULL,
    [NewEmail]    VARCHAR (50)  NULL,
    [NewMobile]   VARCHAR (20)  NULL,
    [ActionType]  VARCHAR (20)  NOT NULL,
    [Operater]    NVARCHAR (30) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_CSSResendBatchBuffer_BatchNumber]
    ON [dbo].[CSSResendBatchBuffer]([BatchNumber] ASC);

