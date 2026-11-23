CREATE TABLE [dbo].[BatchMemoRowBuffer] (
    [Id]            INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BatchMemoId]   INT             NOT NULL,
    [GUID]          VARCHAR (40)    NULL,
    [Alias]         VARCHAR (20)    NULL,
    [VoucherNumber] VARCHAR (50)    NULL,
    [Memo]          NVARCHAR (2000) NOT NULL,
    [IsSuccess]     BIT             NOT NULL,
    [StatusMessage] NVARCHAR (500)  NULL,
    [CreatedTime]   DATETIME        NOT NULL,
    [SessionId]     VARCHAR (100)   NULL,
    CONSTRAINT [PK_BatchMemoRowBuffer] PRIMARY KEY CLUSTERED ([Id] ASC)
);

