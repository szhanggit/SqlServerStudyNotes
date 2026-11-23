CREATE TABLE [dbo].[BatchAbnormalAccountActivity] (
    [BatchId]       BIGINT       NOT NULL,
    [AccountNumber] VARCHAR (50) NOT NULL,
    [ProgramCode]   VARCHAR (20) NOT NULL,
    [TranType]      SMALLINT     NOT NULL,
    [TranCount]     INT          NOT NULL,
    [TranAmount]    BIGINT       NOT NULL,
    [TranSuccess]   BIT          NOT NULL,
    CONSTRAINT [FK_BatchAbnormalAccountActivity_Batch_BatchId] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[Batch] ([Id])
);

