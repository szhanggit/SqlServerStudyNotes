CREATE TABLE [dbo].[UploadFileType] (
    [Id]                INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FileType]          TINYINT        NOT NULL,
    [AllowedFileFormat] VARCHAR (500)  NOT NULL,
    [MaxSize]           INT            NOT NULL,
    [Comment]           NVARCHAR (500) NULL,
    CONSTRAINT [PK_UploadFileType_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Separated by "|" like *.xls|*.xlsx|*.txt', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'UploadFileType', @level2type = N'COLUMN', @level2name = N'AllowedFileFormat';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'in kb (K Byte)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'UploadFileType', @level2type = N'COLUMN', @level2name = N'MaxSize';

