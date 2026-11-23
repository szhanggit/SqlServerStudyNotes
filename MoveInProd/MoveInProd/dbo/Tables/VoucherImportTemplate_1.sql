CREATE TABLE [dbo].[VoucherImportTemplate] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TemplateName] NVARCHAR (100) NOT NULL,
    [ProgramId]    INT            NULL,
    CONSTRAINT [PK_VoucherImportTemplate_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_VoucherImportTemplate_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id])
);

