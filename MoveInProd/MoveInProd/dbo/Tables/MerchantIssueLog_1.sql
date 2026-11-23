CREATE TABLE [dbo].[MerchantIssueLog] (
    [VoucherNumber]   NVARCHAR (100) NOT NULL,
    [ID]              BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MerchantCode]    NVARCHAR (200) NOT NULL,
    [TXSystem]        TINYINT        NOT NULL,
    [OrderNumber]     NVARCHAR (200) NULL,
    [IssueDate]       DATETIME       NOT NULL,
    [CreationDate]    DATETIME       CONSTRAINT [DF_MerchantIssueLog_CreationDate] DEFAULT (getdate()) NULL,
    [ProcessResult]   NVARCHAR (MAX) NULL,
    [ApplicationName] NVARCHAR (100) NULL,
    [ProcessFlag]     BIT            CONSTRAINT [DF_MerchantIssueLog_ProcessFlag] DEFAULT ((0)) NOT NULL,
    [RunTime]         SMALLINT       CONSTRAINT [DF_MerchantIssueLog_RunTime] DEFAULT ((0)) NOT NULL,
    [UpdateDate]      DATETIME       NULL,
    [ExpireDate]      DATETIME       NULL,
    CONSTRAINT [PK_MerchantIssueLog] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);

