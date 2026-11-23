CREATE TABLE [merchant_info].[tb_if_imported_file] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [program_id]       INT            NOT NULL,
    [name]             NVARCHAR (100) NOT NULL,
    [created_by]       NVARCHAR (50)  NOT NULL,
    [created_datetime] DATETIME       NOT NULL,
    [updated_by]       NVARCHAR (50)  NULL,
    [updated_datetime] DATETIME       NULL,
    CONSTRAINT [PK_import_file] PRIMARY KEY CLUSTERED ([id] ASC)
);

