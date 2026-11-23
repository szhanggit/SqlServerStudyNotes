CREATE TABLE [dbo].[VoucherSupplierAPILog_TPC] (
    [Id]                  BIGINT         IDENTITY (1, 1) NOT NULL,
    [LocalId]             BIGINT         NOT NULL,
    [OperationName]       VARCHAR (50)   NOT NULL,
    [RequestId]           VARCHAR (50)   NOT NULL,
    [CreatedOn]           DATETIME       NOT NULL,
    [ResponseCode]        VARCHAR (50)   NULL,
    [Comment]             NVARCHAR (MAX) NULL,
    [ResponsedOn]         DATETIME       NULL,
    [RequestMessage]      NVARCHAR (MAX) NULL,
    [ResponseMessage]     NVARCHAR (MAX) NULL,
    [OriginalRequestId]   VARCHAR (50)   NULL,
    [ExternalProductCode] VARCHAR (50)   NULL,
    [SupplierCode]        NVARCHAR (50)  NULL,
    [ProductCode]         VARCHAR (50)   NULL,
    CONSTRAINT [PK_VoucherSupplierAPILog_TPC_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_Self_RequestId]
    ON [dbo].[VoucherSupplierAPILog_TPC]([RequestId] ASC);

