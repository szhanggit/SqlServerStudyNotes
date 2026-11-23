CREATE TABLE [dbo].[VoucherNumberRule] (
    [Id]                       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherNumberPrefix]      VARCHAR (15) NULL,
    [VoucherNumberType]        TINYINT      NOT NULL,
    [VoucherNumberLength]      TINYINT      NOT NULL,
    [VoucherNumberExample]     VARCHAR (50) NOT NULL,
    [VoucherNumberAlgorithmId] INT          NOT NULL,
    [VoucherGenerator]         TINYINT      NOT NULL,
    CONSTRAINT [PK_VOUCHERNUMBERRULE] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherNumberRule_VoucherNumberAlgorithm_VoucherNumberAlgorithmId] FOREIGN KEY ([VoucherNumberAlgorithmId]) REFERENCES [dbo].[VoucherNumberAlgorithm] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1--Pure Digital
   2--Letter + Digital', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VoucherNumberRule', @level2type = N'COLUMN', @level2name = N'VoucherNumberType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The length doesn''t include prefix', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VoucherNumberRule', @level2type = N'COLUMN', @level2name = N'VoucherNumberLength';

