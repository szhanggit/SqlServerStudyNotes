CREATE TABLE [dbo].[BatchTransactionDetail] (
    [Id]                     BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BatchTransactionId]     BIGINT          NOT NULL,
    [ProgramCode]            VARCHAR (20)    NOT NULL,
    [VoucherNumber]          VARCHAR (50)    NOT NULL,
    [TranType]               SMALLINT        NOT NULL,
    [TranCode]               VARCHAR (50)    NULL,
    [TranCodeRef]            VARCHAR (50)    NULL,
    [Amount]                 INT             NULL,
    [MerchantCode]           VARCHAR (50)    NULL,
    [ShopCode]               VARCHAR (50)    NULL,
    [TerminalCode]           VARCHAR (50)    NULL,
    [SettleDate]             INT             NULL,
    [Reason]                 NVARCHAR (1000) NULL,
    [ResponseCode]           VARCHAR (5)     NULL,
    [Comment]                NVARCHAR (MAX)  NULL,
    [TranRealDateTime]       DATETIME        NULL,
    [Rsv1]                   NVARCHAR (255)  NULL,
    [Rsv2]                   NVARCHAR (255)  NULL,
    [Rsv3]                   NVARCHAR (255)  NULL,
    [BatchTransactionTaskId] BIGINT          NULL,
    [ExpiryDate]             DATETIME        NULL,
    [VoucherGuid]            NVARCHAR (50)   NULL,
    [MGCType]                TINYINT         NULL,
    [ChildVouchers]          VARCHAR (3600)  NULL,
    [Alias]                  VARCHAR (20)    NULL,
    [BusinessDate]           INT             NULL,
    CONSTRAINT [PK_BatchTransactionDetail_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BatchTransactionDetail_BatchTransaction_BatchTransactionId] FOREIGN KEY ([BatchTransactionId]) REFERENCES [dbo].[BatchTransaction] ([Id]),
    CONSTRAINT [FK_BatchTransactionDetail_BatchTransactionTask_BatchTransactionId] FOREIGN KEY ([BatchTransactionTaskId]) REFERENCES [dbo].[BatchTransactionTask] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_BatchTransactionDetail_BatchTransactionId]
    ON [dbo].[BatchTransactionDetail]([BatchTransactionId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_BatchTransactionDetail_Voucher]
    ON [dbo].[BatchTransactionDetail]([ProgramCode] ASC, [VoucherNumber] ASC);

