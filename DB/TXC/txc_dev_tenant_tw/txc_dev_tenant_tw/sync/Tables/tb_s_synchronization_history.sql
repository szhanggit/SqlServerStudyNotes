CREATE TABLE [sync].[tb_s_synchronization_history] (
    [sync_history_id] BIGINT         IDENTITY (1, 1) NOT NULL,
    [sync_id]         INT            NOT NULL,
    [pipeline_run_id] VARCHAR (50)   NOT NULL,
    [trigger_time]    DATETIME       NOT NULL,
    [status]          NVARCHAR (20)  NOT NULL,
    [remarks]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_tb_s_synchronization_history] PRIMARY KEY CLUSTERED ([sync_history_id] ASC)
);

