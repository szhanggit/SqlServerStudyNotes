CREATE TABLE [dbo].[AcceptanceLoop] (
    [Id]         INT          IDENTITY (1, 1) NOT NULL,
    [ProgramId]  INT          NOT NULL,
    [ProductId]  INT          NULL,
    [ExternalId] VARCHAR (50) NOT NULL,
    [Status]     INT          NOT NULL,
    CONSTRAINT [PK_AcceptanceLoop_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_AcceptanceLoop_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_AcceptanceLoop_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [AK_AcceptanceLoop_ProgramId_ExternalId] UNIQUE CLUSTERED ([ProgramId] ASC, [ExternalId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_AcceptanceLoop_Id_ProductId]
    ON [dbo].[AcceptanceLoop]([Id] ASC, [ProductId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_AcceptanceLoop_ProductId_Id]
    ON [dbo].[AcceptanceLoop]([ProductId] ASC, [Id] ASC);

