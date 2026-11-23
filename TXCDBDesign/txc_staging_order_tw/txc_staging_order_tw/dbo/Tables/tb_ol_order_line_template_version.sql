CREATE TABLE [dbo].[tb_ol_order_line_template_version] (
    [order_line_template_version_id]   INT        IDENTITY (1, 1) NOT NULL,
    [template_version_id]              INT        NOT NULL,
    [order_line_template_tag_value_id] INT        NULL,
    [row_version]                      ROWVERSION NOT NULL,
    CONSTRAINT [PK_tb_ol_order_line_template_version] PRIMARY KEY CLUSTERED ([order_line_template_version_id] ASC),
    CONSTRAINT [FK_tb_ol_order_line_template_version_tb_ol_order_line_template_tag_value] FOREIGN KEY ([order_line_template_tag_value_id]) REFERENCES [dbo].[tb_ol_order_line_template_tag_value] ([order_line_template_tag_value_id])
);

