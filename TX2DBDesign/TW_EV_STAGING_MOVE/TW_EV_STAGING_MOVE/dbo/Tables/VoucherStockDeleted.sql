CREATE TABLE [dbo].[VoucherStockDeleted] (
    [Id]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProgramId]          INT           NOT NULL,
    [ProductId]          INT           NOT NULL,
    [VoucherNumber]      VARCHAR (50)  NULL,
    [ShortUrl]           VARCHAR (15)  NOT NULL,
    [AuthCode]           VARCHAR (10)  NULL,
    [SessionId]          VARCHAR (50)  NULL,
    [StockStatus]        TINYINT       NOT NULL,
    [CreateTime]         DATETIME      NOT NULL,
    [AssignTime]         DATETIME      NULL,
    [GUID]               VARCHAR (50)  NULL,
    [BalanceAvailable]   INT           NULL,
    [ReservationBatchId] BIGINT        NULL,
    [ExpiryDate]         DATETIME      NULL,
    [PinCode]            VARCHAR (100) NULL,
    [DeleteTime]         DATETIME      NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

