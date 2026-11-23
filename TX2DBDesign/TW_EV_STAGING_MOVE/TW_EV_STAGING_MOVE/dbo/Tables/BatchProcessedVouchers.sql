CREATE TABLE [dbo].[BatchProcessedVouchers] (
    [Id]        BIGINT           IDENTITY (1, 1) NOT NULL,
    [VoucherId] BIGINT           NOT NULL,
    [SessionId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_BatchProcessedVouchers_Id] PRIMARY KEY CLUSTERED ([Id] DESC)
);


GO
CREATE NONCLUSTERED INDEX [Index_Self_RequestId]
    ON [dbo].[BatchProcessedVouchers]([SessionId] ASC);

