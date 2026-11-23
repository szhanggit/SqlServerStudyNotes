CREATE TABLE [dbo].[VoucherStock__f] (
    [Id]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProgramId]          INT           NOT NULL,
    [ProductId]          INT           NOT NULL,
    [VoucherNumber]      VARCHAR (50)  NOT NULL,
    [ShortUrl]           VARCHAR (15)  COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [AuthCode]           VARCHAR (10)  NULL,
    [SessionId]          VARCHAR (50)  NULL,
    [StockStatus]        INT           NOT NULL,
    [CreateTime]         DATETIME      NOT NULL,
    [AssignTime]         DATETIME      NULL,
    [GUID]               VARCHAR (50)  NULL,
    [BalanceAvailable]   INT           NULL,
    [ReservationBatchId] BIGINT        NULL,
    [ExpiryDate]         DATETIME      NULL,
    [PinCode]            VARCHAR (100) NULL,
    CONSTRAINT [PK__VoucherS__3214EC077626CF7C] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ__VoucherS__C1941A125E965B59] UNIQUE NONCLUSTERED ([VoucherNumber] ASC, [ProgramId] ASC) WITH (IGNORE_DUP_KEY = ON),
    CONSTRAINT [UQ__VoucherS__FFEE2EA2694F87D1] UNIQUE NONCLUSTERED ([ShortUrl] ASC) WITH (IGNORE_DUP_KEY = ON)
);


GO
CREATE NONCLUSTERED INDEX [index_StockStatus_Stock]
    ON [dbo].[VoucherStock__f]([ProductId] ASC)
    INCLUDE([ProgramId], [VoucherNumber], [BalanceAvailable], [ExpiryDate], [GUID], [ReservationBatchId], [ShortUrl], [AuthCode], [SessionId]) WHERE ([StockStatus]=(0));


GO
CREATE NONCLUSTERED INDEX [index_StockStatus_Locked]
    ON [dbo].[VoucherStock__f]([SessionId] ASC)
    INCLUDE([ProgramId], [VoucherNumber], [ProductId], [BalanceAvailable], [ExpiryDate], [GUID], [ReservationBatchId], [ShortUrl], [AuthCode]) WHERE ([StockStatus]=(2));


GO
CREATE NONCLUSTERED INDEX [index_StockStatus_NeedFetch]
    ON [dbo].[VoucherStock__f]([SessionId] ASC) WHERE ([StockStatus]=(3));

