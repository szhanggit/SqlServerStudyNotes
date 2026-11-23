CREATE TABLE [dbo].[ClientQuotationAttachment] (
    [Id]                INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientQuotationId] INT            NOT NULL,
    [UploadFileTypeId]  INT            NOT NULL,
    [FileName]          NVARCHAR (200) NOT NULL,
    [FileFullName]      NVARCHAR (500) NOT NULL,
    [Uploader]          NVARCHAR (100) NOT NULL,
    [UploadedOn]        DATETIME       NOT NULL,
    CONSTRAINT [PK_ClientQuotationAttachment_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ClientQuotationAttachment_ClientQuotation_ClientQuotationId] FOREIGN KEY ([ClientQuotationId]) REFERENCES [dbo].[ClientQuotation] ([Id]),
    CONSTRAINT [FK_ClientQuotationAttachment_UploadFileType_UploadFileTypeId] FOREIGN KEY ([UploadFileTypeId]) REFERENCES [dbo].[UploadFileType] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'in kb (K Byte)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ClientQuotationAttachment', @level2type = N'COLUMN', @level2name = N'FileName';

