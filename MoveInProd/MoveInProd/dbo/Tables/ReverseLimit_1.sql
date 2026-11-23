CREATE TABLE [dbo].[ReverseLimit] (
    [Id]            INT     IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Type]          TINYINT NOT NULL,
    [ValidPeriod]   INT     NOT NULL,
    [IsEndOfDay]    BIT     NOT NULL,
    [DisplayNameId] INT     NOT NULL,
    CONSTRAINT [PK_ReverseLimit_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ReverseLimit_Dictionary_DisplayNameId] FOREIGN KEY ([DisplayNameId]) REFERENCES [dbo].[Dictionary] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--cannot reversed
   2--Always can reversed
   3--Within n hours
   4--Within n weeks
   5--Within n month', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ReverseLimit', @level2type = N'COLUMN', @level2name = N'Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'this value could be n day or month or the Nth end of montn', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ReverseLimit', @level2type = N'COLUMN', @level2name = N'ValidPeriod';

