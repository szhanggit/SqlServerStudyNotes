CREATE TABLE [template].[tb_t_template_version] (
    [template_version_id]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [template_id]                    INT            NOT NULL,
    [language_id]                    INT            NOT NULL,
    [version]                        INT            NOT NULL,
    [is_current_version]             BIT            NOT NULL,
    [description]                    NVARCHAR (500) NULL,
    [subject1]                       NVARCHAR (500) NULL,
    [content1]                       NVARCHAR (MAX) NOT NULL,
    [subject2]                       NVARCHAR (500) NULL,
    [content2]                       NVARCHAR (MAX) NULL,
    [subject3]                       NVARCHAR (500) NULL,
    [content3]                       NVARCHAR (MAX) NULL,
    [TX2ConnectionId]                INT            NULL,
    [attachment_template_version_id] INT            NULL,
    [timestamp]                      ROWVERSION     NOT NULL,
    [created_by]                     NVARCHAR (250) NULL,
    [created_on]                     DATETIME       NULL,
    [last_modified_by]               NVARCHAR (250) NULL,
    [last_modified_on]               DATETIME       NULL,
    CONSTRAINT [PK_tb_t_template_version_template_version_id] PRIMARY KEY CLUSTERED ([template_version_id] ASC),
    CONSTRAINT [UK_template_id_language_id_version] UNIQUE NONCLUSTERED ([template_id] ASC, [language_id] ASC, [version] ASC)
);

