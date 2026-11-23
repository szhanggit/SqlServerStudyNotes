CREATE TABLE [dbo].[OrderAttachment] (
    [Id]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderNumber]      VARCHAR (50)   NOT NULL,
    [UploadFileTypeId] INT            NOT NULL,
    [FileName]         NVARCHAR (200) NOT NULL,
    [FileFullName]     NVARCHAR (500) NOT NULL,
    [Uploader]         NVARCHAR (100) NOT NULL,
    [UploadedOn]       DATETIME       NOT NULL,
    CONSTRAINT [PK_OrderAttachment_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_OrderAttachment_UploadFileType_UploadFileTypeId] FOREIGN KEY ([UploadFileTypeId]) REFERENCES [dbo].[UploadFileType] ([Id])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'in kb (K Byte)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'OrderAttachment', @level2type = N'COLUMN', @level2name = N'FileName';

