CREATE TABLE [dbo].[tb_gd_general_dictionary] (
    [dictionary_id]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [tenant_id]       INT            NOT NULL,
    [category]        NVARCHAR (50)  NOT NULL,
    [name]            NVARCHAR (50)  NOT NULL,
    [display_name]    NVARCHAR (500) NOT NULL,
    [parent_id]       INT            NULL,
    [created_by]      NVARCHAR (250) NOT NULL,
    [created_on]      DATETIME       NOT NULL,
    [last_updated_by] NVARCHAR (250) NULL,
    [last_updated_on] DATETIME       NULL,
    CONSTRAINT [PK_general_dictionary_dictionary_id] PRIMARY KEY NONCLUSTERED ([dictionary_id] ASC)
);

