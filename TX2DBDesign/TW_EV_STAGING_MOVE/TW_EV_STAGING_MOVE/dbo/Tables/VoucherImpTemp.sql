CREATE TABLE [dbo].[VoucherImpTemp] (
    [SessionId]          VARCHAR (50)  NOT NULL,
    [ProductId]          INT           NOT NULL,
    [ProgramId]          INT           NOT NULL,
    [VoucherNumber]      VARCHAR (50)  NOT NULL,
    [BalanceAvailable]   INT           NOT NULL,
    [Status]             INT           NOT NULL,
    [ReservationBatchId] INT           NOT NULL,
    [CreationTime]       DATETIME      NOT NULL,
    [ExpiryDate]         DATETIME      NULL,
    [PinCode]            VARCHAR (100) NULL
);

