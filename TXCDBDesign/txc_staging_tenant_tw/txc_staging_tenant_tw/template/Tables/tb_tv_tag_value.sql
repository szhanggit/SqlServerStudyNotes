CREATE TABLE [template].[tb_tv_tag_value] (
    [tag_value_id]             INT            IDENTITY (1, 1) NOT NULL,
    [tag_id]                   INT            NOT NULL,
    [html_value]               NVARCHAR (MAX) NULL,
    [text_value]               NVARCHAR (MAX) NULL,
    [apply_condition_id]       INT            NULL,
    [draft_text_value]         NVARCHAR (MAX) NULL,
    [draft_html_value]         NVARCHAR (MAX) NULL,
    [draft_apply_condition_id] INT            NULL,
    [is_default]               BIT            NOT NULL,
    [created_by]               NVARCHAR (250) NOT NULL,
    [created_on]               DATETIME       NOT NULL,
    [approved_by]              NVARCHAR (250) NULL,
    [approved_on]              DATETIME       NULL,
    [last_updated_by]          NVARCHAR (250) NULL,
    [last_updated_on]          DATETIME       NULL,
    [timestamp]                ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_tv_tag_value] PRIMARY KEY CLUSTERED ([tag_value_id] ASC)
);

