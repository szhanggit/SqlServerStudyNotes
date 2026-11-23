CREATE TABLE [dbo].[CTBCRedemptionLog] (
    [Id]                INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VoucherNumber]     VARCHAR (50)   NOT NULL,
    [MerchantCode]      VARCHAR (50)   NULL,
    [ProgramCode]       VARCHAR (20)   NULL,
    [TXSystem]          TINYINT        NOT NULL,
    [ClientOrderNumber] VARCHAR (50)   NULL,
    [OrderNumber]       VARCHAR (50)   NULL,
    [ProductCode]       VARCHAR (50)   NOT NULL,
    [ActionDate]        DATETIME       NOT NULL,
    [ProcessDate]       DATETIME       NULL,
    [CreationDate]      DATETIME       DEFAULT (getdate()) NOT NULL,
    [ProcessResult]     NVARCHAR (MAX) NULL,
    [ProcessFlag]       BIT            NOT NULL,
    CONSTRAINT [PK_CTBCRedemptionLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

