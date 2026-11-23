CREATE TABLE [dbo].[tb_odsh_order_distribution_status_history] (
    [id]            INT           IDENTITY (1, 1) NOT NULL,
    [order_id]      INT           NOT NULL,
    [action_type]   NVARCHAR (50) NOT NULL,
    [action_result] NVARCHAR (20) NOT NULL,
    [action_time]   DATETIME      NOT NULL,
    [operator]      NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_tb_odsh_order_distribution_status_history] PRIMARY KEY CLUSTERED ([id] ASC)
);

