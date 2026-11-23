CREATE TABLE [dbo].[tb_ol_order_line_template_set] (
    [order_line_template_set_id]     INT        IDENTITY (1, 1) NOT NULL,
    [order_line_template_id]         INT        NOT NULL,
    [template_type]                  TINYINT    NOT NULL,
    [template_sub_type]              TINYINT    NULL,
    [order_line_template_version_id] INT        NOT NULL,
    [row_version]                    ROWVERSION NOT NULL,
    CONSTRAINT [PK_tb_ol_order_line_template_set] PRIMARY KEY CLUSTERED ([order_line_template_set_id] ASC),
    CONSTRAINT [FK_tb_ol_order_line_template_set_tb_ol_order_line_template] FOREIGN KEY ([order_line_template_id]) REFERENCES [dbo].[tb_ol_order_line_template] ([order_line_template_id]),
    CONSTRAINT [FK_tb_ol_order_line_template_set_tb_ol_order_line_template_version] FOREIGN KEY ([order_line_template_version_id]) REFERENCES [dbo].[tb_ol_order_line_template_version] ([order_line_template_version_id])
);

