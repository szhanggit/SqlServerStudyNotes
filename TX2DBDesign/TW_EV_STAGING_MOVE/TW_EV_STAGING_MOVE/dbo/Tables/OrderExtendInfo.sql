CREATE TABLE [dbo].[OrderExtendInfo] (
    [Id]                        INT            NOT NULL,
    [CPClientCode]              NVARCHAR (100) NOT NULL,
    [CPClientName]              NVARCHAR (255) NOT NULL,
    [VoucherFileName]           NVARCHAR (500) NULL,
    [VoucherFilePassword]       VARCHAR (50)   NULL,
    [VoucherFileChecksum]       VARCHAR (128)  NULL,
    [VoucherFileGenerationTime] DATETIME       NULL,
    [CreatedOn]                 DATETIME       NOT NULL,
    [NeedSendWhenPublish]       BIT            NULL,
    [CreateOrderRequestId]      VARCHAR (50)   NULL,
    [LastUpdatedOn]             DATETIME       NULL,
    [NeedRegenerateFile]        BIT            NULL,
    [DetailFileName]            NVARCHAR (500) NULL,
    [DetailFilePassword]        VARCHAR (50)   NULL,
    [DetailFileChecksum]        VARCHAR (128)  NULL,
    [CPClientId]                INT            NULL,
    [Channel]                   VARCHAR (15)   NULL,
    CONSTRAINT [PK_OrderExtendInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderExtendInfo_Order_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[Order] ([Id])
);

