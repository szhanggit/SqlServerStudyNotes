CREATE TABLE [dbo].[PreIssueVoucherInfo] (
    [Id]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProgramId]          INT           NOT NULL,
    [ProductId]          INT           NOT NULL,
    [VoucherNumber]      VARCHAR (50)  NOT NULL,
    [ShortUrl]           VARCHAR (20)  NOT NULL,
    [AuthCode]           VARCHAR (20)  NOT NULL,
    [Status]             INT           NOT NULL,
    [GUID]               VARCHAR (50)  NULL,
    [BalanceAvailable]   INT           NOT NULL,
    [ReservationBatchId] BIGINT        NOT NULL,
    [AvailableEndDate]   INT           NOT NULL,
    [ExpiryDate]         DATETIME      NULL,
    [PinCode]            VARCHAR (100) NULL,
    [ExtendId]           BIGINT        NOT NULL,
    [BatchInfoId]        INT           NOT NULL,
    CONSTRAINT [PK_PreIssueVoucherInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_PreIssueVoucherInfo_BatchInfoId]
    ON [dbo].[PreIssueVoucherInfo]([BatchInfoId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_PreIssueVoucherInfo_Status]
    ON [dbo].[PreIssueVoucherInfo]([Status] ASC) WITH (FILLFACTOR = 90);

