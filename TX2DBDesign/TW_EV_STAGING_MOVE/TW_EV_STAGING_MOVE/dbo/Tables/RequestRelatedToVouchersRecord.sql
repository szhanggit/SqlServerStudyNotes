CREATE TABLE [dbo].[RequestRelatedToVouchersRecord] (
    [Id]          BIGINT           IDENTITY (1, 1) NOT NULL,
    [VoucherGUID] UNIQUEIDENTIFIER NOT NULL,
    [RequestId]   VARCHAR (50)     NOT NULL,
    [CreatedTime] DATETIME         NOT NULL,
    [VendorCode]  VARCHAR (50)     NULL,
    CONSTRAINT [PK_RequestRelatedToVouchersRecord_Id] PRIMARY KEY CLUSTERED ([Id] DESC)
);


GO
CREATE NONCLUSTERED INDEX [Index_Self_RequestId]
    ON [dbo].[RequestRelatedToVouchersRecord]([RequestId] ASC);

