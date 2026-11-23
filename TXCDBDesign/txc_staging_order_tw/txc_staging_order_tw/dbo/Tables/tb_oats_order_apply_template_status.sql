CREATE TABLE [dbo].[tb_oats_order_apply_template_status] (
    [batch_guid]         VARCHAR (50) NOT NULL,
    [product_version_id] INT          NOT NULL,
    [start_datetime]     DATETIME     NULL,
    [completed_datetime] DATETIME     NULL,
    [total_count]        INT          NOT NULL,
    [update_count]       INT          DEFAULT ((0)) NOT NULL,
    [status]             INT          NOT NULL,
    CONSTRAINT [PK_tb_oats_order_apply_template_status] PRIMARY KEY CLUSTERED ([batch_guid] ASC)
);

