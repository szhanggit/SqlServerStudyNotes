CREATE TABLE [dbo].[TPCMutiVouchersCorrelationRecords] (
    [Id]           BIGINT           IDENTITY (1, 1) NOT NULL,
    [RequestId]    VARCHAR (50)     NOT NULL,
    [TPCRequestId] UNIQUEIDENTIFIER NOT NULL,
    [ProductCode]  VARCHAR (50)     NOT NULL,
    [VoucherId]    BIGINT           NOT NULL,
    [VoucherGuid]  UNIQUEIDENTIFIER NOT NULL,
    [CreatedOn]    DATETIME         NOT NULL,
    [RSV1]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_TPCMutiVouchersCorrelationRecords_Id] PRIMARY KEY CLUSTERED ([Id] DESC),
    UNIQUE NONCLUSTERED ([RequestId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Index_Self_RequestId]
    ON [dbo].[TPCMutiVouchersCorrelationRecords]([RequestId] ASC);

