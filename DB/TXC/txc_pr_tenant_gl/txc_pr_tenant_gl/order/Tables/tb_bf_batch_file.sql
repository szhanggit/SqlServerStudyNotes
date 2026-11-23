CREATE TABLE [order].[tb_bf_batch_file] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [remote_location] NVARCHAR (250) NOT NULL,
    [size]            BIGINT         NOT NULL,
    [saved_date]      DATETIME       NOT NULL,
    [file_name]       NVARCHAR (250) NOT NULL,
    [status]          INT            CONSTRAINT [DF_tb_bf_batch_file] DEFAULT ((0)) NOT NULL,
    [optimistic_lock] NVARCHAR (64)  NULL,
    CONSTRAINT [PK_tb_bf_batch_file] PRIMARY KEY CLUSTERED ([id] ASC)
);

