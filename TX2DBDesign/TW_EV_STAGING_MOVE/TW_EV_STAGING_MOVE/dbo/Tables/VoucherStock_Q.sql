CREATE TABLE [dbo].[VoucherStock_Q] (
    [Id]                 BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProgramId]          INT           NOT NULL,
    [ProductId]          INT           NOT NULL,
    [VoucherNumber]      VARCHAR (50)  NOT NULL,
    [ShortUrl]           VARCHAR (20)  COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [AuthCode]           VARCHAR (20)  NULL,
    [SessionId]          VARCHAR (50)  NULL,
    [StockStatus]        INT           NOT NULL,
    [CreateTime]         DATETIME      NOT NULL,
    [AssignTime]         DATETIME      NULL,
    [GUID]               VARCHAR (50)  NULL,
    [BalanceAvailable]   INT           NULL,
    [ReservationBatchId] BIGINT        NULL,
    [ExpiryDate]         DATETIME      NULL,
    [PinCode]            VARCHAR (100) NULL,
    CONSTRAINT [PK__VoucherS__3214EC075A30E3E1] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ__VoucherS__00490498A6264CBC] UNIQUE NONCLUSTERED ([ProgramId] ASC, [VoucherNumber] ASC) WITH (IGNORE_DUP_KEY = ON),
    CONSTRAINT [UQ__VoucherS__FFEE2EA27BBEA073] UNIQUE NONCLUSTERED ([ShortUrl] ASC) WITH (IGNORE_DUP_KEY = ON)
);


GO
CREATE NONCLUSTERED INDEX [index_StockStatus_Stock]
    ON [dbo].[VoucherStock_Q]([ProductId] ASC)
    INCLUDE([ProgramId], [VoucherNumber], [BalanceAvailable], [ExpiryDate], [GUID], [ReservationBatchId], [ShortUrl], [AuthCode], [SessionId]) WHERE ([StockStatus]=(0));


GO
CREATE NONCLUSTERED INDEX [index_StockStatus_Locked]
    ON [dbo].[VoucherStock_Q]([SessionId] ASC)
    INCLUDE([ProgramId], [VoucherNumber], [ProductId], [BalanceAvailable], [ExpiryDate], [GUID], [ReservationBatchId], [ShortUrl], [AuthCode]) WHERE ([StockStatus]=(2));


GO
CREATE NONCLUSTERED INDEX [index_StockStatus_NeedFetch]
    ON [dbo].[VoucherStock_Q]([SessionId] ASC) WHERE ([StockStatus]=(3));

