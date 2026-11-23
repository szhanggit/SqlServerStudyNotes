CREATE TABLE [dbo].[BatchDetail] (
    [BatchId]     BIGINT       NOT NULL,
    [ProgramCode] VARCHAR (20) NOT NULL,
    CONSTRAINT [FK_BatchDetail_Batch_BatchId] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[Batch] ([Id])
);

