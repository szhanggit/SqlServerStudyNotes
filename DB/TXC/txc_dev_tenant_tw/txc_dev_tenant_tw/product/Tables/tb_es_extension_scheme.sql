CREATE TABLE [product].[tb_es_extension_scheme] (
    [extension_scheme_id] INT            IDENTITY (1, 1) NOT NULL,
    [name]                NVARCHAR (50)  NOT NULL,
    [display_name]        NVARCHAR (500) NOT NULL,
    [type]                TINYINT        NOT NULL,
    [valid_period]        SMALLINT       NULL,
    CONSTRAINT [PK_extension_scheme_id] PRIMARY KEY CLUSTERED ([extension_scheme_id] ASC)
);

