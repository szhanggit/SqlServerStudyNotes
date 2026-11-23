CREATE TABLE [dbo].[InstanceConfig] (
    [ConfigName]  VARCHAR (20)  NOT NULL,
    [ConfigValue] NVARCHAR (30) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_InstanceConfig_Instance]
    ON [dbo].[InstanceConfig]([ConfigName] ASC);

