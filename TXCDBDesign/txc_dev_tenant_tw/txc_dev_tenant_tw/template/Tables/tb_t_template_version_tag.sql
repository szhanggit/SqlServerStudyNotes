CREATE TABLE [template].[tb_t_template_version_tag] (
    [template_version_tag_id] INT IDENTITY (1, 1) NOT NULL,
    [template_version_id]     INT NOT NULL,
    [tag_id]                  INT NOT NULL,
    CONSTRAINT [PK_template_version_tag_id] PRIMARY KEY CLUSTERED ([template_version_tag_id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_template_version_id_tag_id]
    ON [template].[tb_t_template_version_tag]([template_version_id] ASC, [tag_id] ASC);

