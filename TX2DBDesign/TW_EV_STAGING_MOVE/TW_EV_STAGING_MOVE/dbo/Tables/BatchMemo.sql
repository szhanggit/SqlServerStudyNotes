CREATE TABLE [dbo].[BatchMemo] (
    [Id]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FileName]      NVARCHAR (300) NOT NULL,
    [BatchNumber]   VARCHAR (50)   NOT NULL,
    [CreatedTime]   DATETIME       NOT NULL,
    [TotalRows]     INT            DEFAULT ((0)) NOT NULL,
    [SuccessRows]   INT            DEFAULT ((0)) NOT NULL,
    [ErrorRows]     INT            DEFAULT ((0)) NOT NULL,
    [UpdatedBy]     VARCHAR (50)   NULL,
    [ProcessedTime] DATETIME       NULL,
    [Status]        INT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Batch_Memo] PRIMARY KEY CLUSTERED ([Id] ASC)
);

