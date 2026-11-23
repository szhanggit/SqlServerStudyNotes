CREATE TABLE [dbo].[TXCProductTemplateSync] (
    [RunId]                VARCHAR (50)   NOT NULL,
    [TXCProductTemplateId] INT            NULL,
    [TemplateType]         TINYINT        NULL,
    [TemplateSubType]      TINYINT        NULL,
    [TXCTemplateVersionId] INT            NULL,
    [TagId]                INT            NULL,
    [Value]                NVARCHAR (MAX) NULL,
    [TextValue]            NVARCHAR (MAX) NULL,
    [TX2TemplateVersionId] INT            NULL,
    [TX2MediaLibraryId]    INT            NULL
);


GO
CREATE CLUSTERED INDEX [IX_TXCProductTemplateSync]
    ON [dbo].[TXCProductTemplateSync]([RunId] ASC, [TXCProductTemplateId] ASC) WITH (FILLFACTOR = 90);

