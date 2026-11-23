CREATE TABLE [dbo].[GROrderGroupFile] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [OrderGroupFileName] NVARCHAR (50) NOT NULL,
    [OrderGroupNumber]   VARCHAR (30)  NULL,
    [OrderCount]         INT           NULL,
    [TotalCount]         INT           NULL,
    [Reason]             NVARCHAR (50) NULL,
    [Status]             INT           NOT NULL,
    CONSTRAINT [PK_GROrderGroupFile_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_GROrderGroupFile_FileName]
    ON [dbo].[GROrderGroupFile]([OrderGroupFileName] ASC);

