CREATE TABLE [dbo].[ConsumeMerchantUploadFileLog] (
    [VoucherNumber]   NVARCHAR (100) NOT NULL,
    [ID]              BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MerchantCode]    NVARCHAR (100) NULL,
    [ProgramCode]     NVARCHAR (10)  NULL,
    [TXSystem]        TINYINT        NOT NULL,
    [OrderNumber]     NVARCHAR (200) NULL,
    [ProductCode]     NVARCHAR (100) NULL,
    [ActionDate]      DATETIME       NULL,
    [ProcessDate]     DATETIME       NULL,
    [CreationDate]    DATETIME       CONSTRAINT [DF_ConsumeMerchantUploadFileLog_CreationDate] DEFAULT (getdate()) NOT NULL,
    [ProcessResult]   NVARCHAR (MAX) NULL,
    [ShopCode]        NVARCHAR (200) NULL,
    [ApplicationName] NVARCHAR (100) NULL,
    [ResponseCode]    NVARCHAR (20)  NULL,
    CONSTRAINT [PK_ConsumeMerchantUploadFileLog] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

