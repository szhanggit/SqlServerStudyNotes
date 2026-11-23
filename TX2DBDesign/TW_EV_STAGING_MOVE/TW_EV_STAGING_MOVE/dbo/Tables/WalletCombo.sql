CREATE TABLE [dbo].[WalletCombo] (
    [Id]             BIGINT IDENTITY (1, 1) NOT NULL,
    [WalletId]       BIGINT NOT NULL,
    [VoucherId]      BIGINT NOT NULL,
    [ChildVoucherId] BIGINT NULL,
    CONSTRAINT [PK_WalletCombo] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_WalletCombo_Voucher] FOREIGN KEY ([ChildVoucherId]) REFERENCES [dbo].[Voucher] ([Id]),
    CONSTRAINT [FK_WalletCombo_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id]),
    CONSTRAINT [FK_WalletCombo_WalletId] FOREIGN KEY ([WalletId]) REFERENCES [dbo].[Wallet] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_WalletCombo_VoucherId]
    ON [dbo].[WalletCombo]([VoucherId] ASC);

