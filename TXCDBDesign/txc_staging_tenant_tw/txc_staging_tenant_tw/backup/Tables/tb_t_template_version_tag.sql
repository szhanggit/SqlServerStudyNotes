CREATE TABLE [backup].[tb_t_template_version_tag] (
    [template_version_tag_id] INT IDENTITY (1, 1) NOT NULL,
    [template_version_id]     INT NOT NULL,
    [tag_id]                  INT NOT NULL
);

