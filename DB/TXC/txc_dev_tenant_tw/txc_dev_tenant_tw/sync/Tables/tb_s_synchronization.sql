CREATE TABLE [sync].[tb_s_synchronization] (
    [sync_id]              INT            NOT NULL,
    [sync_name]            NVARCHAR (100) NOT NULL,
    [description]          NVARCHAR (500) NULL,
    [status]               NVARCHAR (20)  NOT NULL,
    [last_success_sync_on] DATETIME       NOT NULL,
    [remarks]              NVARCHAR (MAX) NULL,
    [last_sync_timestamp]  BINARY (8)     NULL,
    CONSTRAINT [PK_tb_s_synchronization] PRIMARY KEY CLUSTERED ([sync_id] ASC)
);

