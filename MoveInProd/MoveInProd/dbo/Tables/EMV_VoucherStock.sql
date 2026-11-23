CREATE TABLE [dbo].[EMV_VoucherStock] (
    [Id]           INT              IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BatchId]      INT              NOT NULL,
    [Denomination] INT              NOT NULL,
    [SKU]          VARCHAR (25)     NOT NULL,
    [VoucherCode]  VARCHAR (50)     NOT NULL,
    [IssueDate]    DATETIME         NOT NULL,
    [ExpiryDate]   DATETIME         NOT NULL,
    [GUID]         UNIQUEIDENTIFIER NOT NULL,
    [GCID]         VARCHAR (50)     NOT NULL,
    [PODate]       VARCHAR (200)    NOT NULL,
    [PONumber]     VARCHAR (200)    NOT NULL,
    [PIN]          VARCHAR (100)    NULL,
    [CreatedTime]  DATETIME         NOT NULL,
    CONSTRAINT [PK_EMV_VoucherStock] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EMV_VoucherStock_Batch_Id] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[EMV_Batch] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [index_EMV_VoucherStock_VoucherCode]
    ON [dbo].[EMV_VoucherStock]([VoucherCode] ASC);

