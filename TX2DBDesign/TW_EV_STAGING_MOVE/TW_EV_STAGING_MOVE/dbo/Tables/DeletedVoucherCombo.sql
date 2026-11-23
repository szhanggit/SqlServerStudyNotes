CREATE TABLE [dbo].[DeletedVoucherCombo] (
    [Id]                       INT            IDENTITY (1, 1) NOT NULL,
    [DeletedVoucherId]         BIGINT         NULL,
    [MasterVoucherId]          BIGINT         NULL,
    [ChildVoucherId]           BIGINT         NULL,
    [Status]                   TINYINT        NULL,
    [ComboOn]                  DATETIME       NULL,
    [MasterRedemptionTranCode] VARCHAR (50)   NULL,
    [UncomboOn]                DATETIME       NULL,
    [UncomboBy]                NVARCHAR (50)  NULL,
    [BatchTransactionDetailId] INT            NOT NULL,
    [SessionId]                VARCHAR (100)  NULL,
    [BackupOn]                 DATETIME       NULL,
    [Channel]                  VARCHAR (100)  NULL,
    [Comment]                  VARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

