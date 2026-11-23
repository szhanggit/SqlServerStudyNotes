CREATE TABLE [dbo].[tb_oah_order_action_history] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [order_id]         INT            NOT NULL,
    [operation]        INT            NOT NULL,
    [operator]         NVARCHAR (50)  NOT NULL,
    [comment]          NVARCHAR (500) NULL,
    [result]           NVARCHAR (50)  NULL,
    [request_id]       NVARCHAR (50)  NULL,
    [created_datetime] DATETIME       NOT NULL,
    [timestamp]        ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_oah_order_action_history] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_oah_order_action_history_tb_om_order_master] FOREIGN KEY ([order_id]) REFERENCES [dbo].[tb_om_order_master] ([id])
);

