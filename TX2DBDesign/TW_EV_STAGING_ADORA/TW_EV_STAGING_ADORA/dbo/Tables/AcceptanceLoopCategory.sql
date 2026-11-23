CREATE TABLE [dbo].[AcceptanceLoopCategory] (
    [Id]               INT IDENTITY (1, 1) NOT NULL,
    [AcceptanceLoopId] INT NOT NULL,
    [CategoryId]       INT NOT NULL,
    CONSTRAINT [PK_AcceptanceLoopCategory_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ALCategory_ALAcceptanceLoop_ALId] FOREIGN KEY ([AcceptanceLoopId]) REFERENCES [dbo].[AcceptanceLoop] ([Id]),
    CONSTRAINT [FK_AlCategory_MerchantCategory_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[MerchantCategory] ([Id]),
    CONSTRAINT [AK_AcceptanceLoopCategory_AcceptanceLoopId_CategoryId] UNIQUE CLUSTERED ([AcceptanceLoopId] ASC, [CategoryId] ASC)
);

