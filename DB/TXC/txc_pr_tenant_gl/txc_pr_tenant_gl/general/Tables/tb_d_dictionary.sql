CREATE TABLE [general].[tb_d_dictionary] (
    [dictionary_id] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [category]      NVARCHAR (50)  NOT NULL,
    [name]          NVARCHAR (100) NOT NULL,
    [display_name]  NVARCHAR (500) NOT NULL,
    [parent_id]     INT            NULL,
    [tx2id]         INT            NULL,
    [timestamp]     ROWVERSION     NOT NULL,
    CONSTRAINT [PK_Dictionary] PRIMARY KEY CLUSTERED ([dictionary_id] ASC),
    CONSTRAINT [UK_Dictionary_Category_Name] UNIQUE NONCLUSTERED ([category] ASC, [name] ASC)
);

