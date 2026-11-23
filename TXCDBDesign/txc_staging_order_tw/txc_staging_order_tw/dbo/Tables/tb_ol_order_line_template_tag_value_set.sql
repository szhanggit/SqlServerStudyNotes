CREATE TABLE [dbo].[tb_ol_order_line_template_tag_value_set] (
    [order_line_template_tag_value_set_id] INT            IDENTITY (1, 1) NOT NULL,
    [order_line_template_tag_value_id]     INT            NOT NULL,
    [tag_id]                               INT            NOT NULL,
    [value]                                NVARCHAR (MAX) NULL,
    [row_version]                          ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_ol_order_line_template_tag_value_set] PRIMARY KEY CLUSTERED ([order_line_template_tag_value_set_id] ASC),
    CONSTRAINT [FK_tb_ol_order_line_template_tag_value_set_tb_ol_order_line_template_tag_value] FOREIGN KEY ([order_line_template_tag_value_id]) REFERENCES [dbo].[tb_ol_order_line_template_tag_value] ([order_line_template_tag_value_id])
);

