CREATE TABLE [dbo].[VoucherActionHistory] (
    [Id]           BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherId]    BIGINT          NOT NULL,
    [ActionType]   SMALLINT        NOT NULL,
    [ActionResult] TINYINT         NOT NULL,
    [Operator]     NVARCHAR (50)   NOT NULL,
    [ActionTime]   DATETIME        NOT NULL,
    [Memo]         NVARCHAR (1000) NULL,
    CONSTRAINT [PK_VOUCHERACTIONHISTORY] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_VoucherActionHistory_Voucher_VoucherId] FOREIGN KEY ([VoucherId]) REFERENCES [dbo].[Voucher] ([Id])
);

