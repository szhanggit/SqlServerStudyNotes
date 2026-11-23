CREATE TABLE [dbo].[VoucherSupplierAPILog_Amazon] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherId]         BIGINT         NOT NULL,
    [OperationName]     VARCHAR (50)   NOT NULL,
    [RequestId]         VARCHAR (50)   NOT NULL,
    [CreatedOn]         DATETIME       NOT NULL,
    [ResponseCode]      VARCHAR (50)   NULL,
    [Comment]           NVARCHAR (MAX) NULL,
    [ResponsedOn]       DATETIME       NULL,
    [RequestMessage]    NVARCHAR (MAX) NULL,
    [ResponseMessage]   NVARCHAR (MAX) NULL,
    [OriginalRequestId] VARCHAR (50)   NULL,
    [GCId]              VARCHAR (50)   NULL,
    CONSTRAINT [PK_VoucherSupplierAPILog_Amazon_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

