CREATE TABLE [dbo].[EMV_Batch] (
    [Id]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FileName]      NVARCHAR (300) NOT NULL,
    [FileSource]    NVARCHAR (20)  NOT NULL,
    [CreatedTime]   DATETIME       NOT NULL,
    [FileType]      INT            DEFAULT ((1)) NOT NULL,
    [TotalRows]     INT            DEFAULT ((1)) NOT NULL,
    [SuccessRows]   INT            DEFAULT ((0)) NOT NULL,
    [ErrorRows]     INT            DEFAULT ((0)) NOT NULL,
    [Status]        INT            DEFAULT ((0)) NOT NULL,
    [UpdatedBy]     VARCHAR (50)   NULL,
    [ProcessedTime] DATETIME       NULL,
    CONSTRAINT [PK_EMV_Batch] PRIMARY KEY CLUSTERED ([Id] ASC)
);

