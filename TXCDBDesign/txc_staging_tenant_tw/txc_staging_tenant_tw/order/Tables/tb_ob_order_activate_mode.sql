CREATE TABLE [order].[tb_ob_order_activate_mode] (
    [id]              INT      IDENTITY (1, 1) NOT NULL,
    [order_id]        INT      NOT NULL,
    [mode]            INT      NOT NULL,
    [after_published] INT      NULL,
    [fix_date]        DATETIME NOT NULL,
    CONSTRAINT [PK_tb_ob_order_activate_mode] PRIMARY KEY CLUSTERED ([id] ASC)
);

