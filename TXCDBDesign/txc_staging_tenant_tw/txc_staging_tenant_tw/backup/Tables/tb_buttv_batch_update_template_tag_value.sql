CREATE TABLE [backup].[tb_buttv_batch_update_template_tag_value] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [batch_guid]       VARCHAR (50)   NOT NULL,
    [tag_id]           INT            NOT NULL,
    [value]            NVARCHAR (MAX) NULL,
    [text_value]       NVARCHAR (MAX) NULL,
    [status]           TINYINT        NOT NULL,
    [remarks]          NVARCHAR (MAX) NULL,
    [created_by]       NVARCHAR (250) NOT NULL,
    [created_on]       DATETIME       NOT NULL,
    [last_modified_by] NVARCHAR (250) NULL,
    [last_modified_on] DATETIME       NULL,
    [pipeline_run_id]  VARCHAR (50)   NULL
);

