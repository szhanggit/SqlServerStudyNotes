CREATE TABLE [dbo].[tb_def_auth_key] (
    [key_name]           NVARCHAR (8)   NOT NULL,
    [key_value]          NVARCHAR (256) NOT NULL,
    [last_validate_time] DATETIME       NULL,
    UNIQUE NONCLUSTERED ([key_name] ASC)
);

