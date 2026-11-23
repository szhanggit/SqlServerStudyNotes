CREATE TABLE [dbo].[VoucherCombo] (
    [Id]                         BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MasterVoucherId]            BIGINT        NOT NULL,
    [ChildVoucherId]             BIGINT        NOT NULL,
    [Status]                     TINYINT       NOT NULL,
    [ComboOn]                    DATETIME      NOT NULL,
    [MasterRedemptionTranCode]   VARCHAR (50)  NULL,
    [UncomboOn]                  DATETIME      NULL,
    [UncomboBy]                  NVARCHAR (50) NULL,
    [MasterRedemptionTranAmount] INT           NULL,
    CONSTRAINT [PK_VoucherCombo_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherCombo_Voucher_ChildVoucherId] FOREIGN KEY ([ChildVoucherId]) REFERENCES [dbo].[Voucher] ([Id]),
    CONSTRAINT [FK_VoucherCombo_Voucher_MasterVoucherId] FOREIGN KEY ([MasterVoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_VoucherCombo]
    ON [dbo].[VoucherCombo]([MasterVoucherId] DESC, [ChildVoucherId] DESC) WITH (IGNORE_DUP_KEY = ON);

