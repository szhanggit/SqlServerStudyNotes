CREATE TABLE [dbo].[ExpirationPolicy] (
    [Id]                 INT     IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Type]               TINYINT NOT NULL,
    [ValidPeriod]        INT     NULL,
    [IsEndOfDay]         BIT     NOT NULL,
    [DisplayNameId]      INT     NOT NULL,
    [PrintDescriptionId] INT     NULL,
    CONSTRAINT [PK_ExpirationPolicy_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ExpirationPolicy_Dictionary_DisplayNameId] FOREIGN KEY ([DisplayNameId]) REFERENCES [dbo].[Dictionary] ([Id]),
    CONSTRAINT [FK_ExpirationPolicy_Dictionary_PrintDescriptionId] FOREIGN KEY ([PrintDescriptionId]) REFERENCES [dbo].[Dictionary] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--No Expiration
   2--Fixed
   3--Flexable expiry at n days after activation
   4--Flexable expiry at n month after activation
   5--Flexable expiry at Nth end of month after activation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ExpirationPolicy', @level2type = N'COLUMN', @level2name = N'Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'this value could be n day or month or the Nth end of montn', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ExpirationPolicy', @level2type = N'COLUMN', @level2name = N'ValidPeriod';

