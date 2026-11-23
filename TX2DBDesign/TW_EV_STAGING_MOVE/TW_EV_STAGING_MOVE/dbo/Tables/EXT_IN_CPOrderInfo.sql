CREATE TABLE [dbo].[EXT_IN_CPOrderInfo] (
    [Id]                        INT            NOT NULL,
    [CPClientCode]              NVARCHAR (100) NOT NULL,
    [CPClientName]              NVARCHAR (255) NOT NULL,
    [VoucherFileName]           NVARCHAR (500) NULL,
    [VoucherFilePassword]       VARCHAR (50)   NULL,
    [VoucherFileChecksum]       VARCHAR (128)  NULL,
    [VoucherFileGenerationTime] DATETIME       NULL,
    [CreatedOn]                 DATETIME       NOT NULL,
    CONSTRAINT [PK_EXT_IN_CPOrderInfo_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EXT_IN_CPOrderInfo_Order_Id] FOREIGN KEY ([Id]) REFERENCES [dbo].[Order] ([Id])
);

