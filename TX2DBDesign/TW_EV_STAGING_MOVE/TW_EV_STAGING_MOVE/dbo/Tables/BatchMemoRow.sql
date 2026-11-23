CREATE TABLE [dbo].[BatchMemoRow] (
    [Id]            INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BatchMemoId]   INT             NOT NULL,
    [GUID]          VARCHAR (40)    NULL,
    [Alias]         VARCHAR (20)    NULL,
    [VoucherNumber] VARCHAR (50)    NULL,
    [Memo]          NVARCHAR (2000) NOT NULL,
    [IsSuccess]     BIT             NOT NULL,
    [StatusMessage] NVARCHAR (500)  NULL,
    [CreatedTime]   DATETIME        NOT NULL,
    CONSTRAINT [PK_BatchMemoRow] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BatchMemoRow] FOREIGN KEY ([BatchMemoId]) REFERENCES [dbo].[BatchMemo] ([Id])
);

