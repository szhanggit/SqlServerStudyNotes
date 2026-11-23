CREATE TABLE [template].[tb_t_template] (
    [template_id]      INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [template_name]    NVARCHAR (100) NOT NULL,
    [type]             INT            NOT NULL,
    [sub_type]         INT            NOT NULL,
    [status]           TINYINT        NOT NULL,
    [default_language] INT            NOT NULL,
    [timestamp]        ROWVERSION     NOT NULL,
    [created_by]       NVARCHAR (250) NULL,
    [created_on]       DATETIME       NULL,
    [last_modified_by] NVARCHAR (250) NULL,
    [last_modified_on] DATETIME       NULL,
    CONSTRAINT [PK_tb_t_template_template_id] PRIMARY KEY CLUSTERED ([template_id] ASC),
    CONSTRAINT [UK_tb_t_template] UNIQUE NONCLUSTERED ([template_name] ASC, [type] ASC, [sub_type] ASC)
);

