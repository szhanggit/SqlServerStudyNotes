CREATE TABLE [product].[tb_buttvd_batch_update_template_tag_value_details] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [batch_guid]       VARCHAR (50)   NOT NULL,
    [product_id]       INT            NOT NULL,
    [status]           TINYINT        NOT NULL,
    [remarks]          NVARCHAR (MAX) NULL,
    [created_by]       NVARCHAR (250) NOT NULL,
    [created_on]       DATETIME       NOT NULL,
    [last_modified_by] NVARCHAR (250) NULL,
    [last_modified_on] DATETIME       NULL,
    CONSTRAINT [PK_tb_buttvd_batch_update_template_tag_value_details_id] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UK_tb_buttvd_batch_update_template_tag_value_details_batch_guid_product_id] UNIQUE NONCLUSTERED ([batch_guid] ASC, [product_id] ASC)
);

