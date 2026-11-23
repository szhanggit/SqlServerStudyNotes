CREATE TABLE [template].[tb_t_tag] (
    [tag_id]                 INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [tag_name]               VARCHAR (50)    NOT NULL,
    [display_name]           NVARCHAR (500)  NOT NULL,
    [description]            NVARCHAR (500)  NULL,
    [category]               TINYINT         NOT NULL,
    [type]                   TINYINT         NOT NULL,
    [scope_level]            TINYINT         NOT NULL,
    [default_value]          NVARCHAR (4000) NULL,
    [apply_to_html_template] BIT             NOT NULL,
    [apply_to_text_template] BIT             NOT NULL,
    [reflection_type]        VARCHAR (100)   NULL,
    [timestamp]              ROWVERSION      NOT NULL,
    CONSTRAINT [PK_tb_t_tag_tag_id] PRIMARY KEY CLUSTERED ([tag_id] ASC),
    CONSTRAINT [UK_tag_name] UNIQUE NONCLUSTERED ([tag_name] ASC)
);

