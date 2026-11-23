CREATE TABLE [dbo].[ForwardReverseTranMapping] (
    [ForwardTranId] INT NOT NULL,
    [ReverseTranId] INT NOT NULL,
    CONSTRAINT [PK_FORWARDREVERSETRANMAPPING] PRIMARY KEY CLUSTERED ([ForwardTranId] ASC, [ReverseTranId] ASC),
    CONSTRAINT [FK_ForwardReverseTranMapping_Dictionary_ForwardTranId] FOREIGN KEY ([ForwardTranId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_ForwardReverseTranMapping_Dictionary_ReverseTranId] FOREIGN KEY ([ReverseTranId]) REFERENCES [dbo].[Dictionary] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--product', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ForwardReverseTranMapping', @level2type = N'COLUMN', @level2name = N'ReverseTranId';

