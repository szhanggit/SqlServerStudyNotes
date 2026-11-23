CREATE TABLE [dbo].[BatchExtend] (
    [Id]            INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FileName]      NVARCHAR (300) NOT NULL,
    [CreatedTime]   DATETIME       NOT NULL,
    [TotalRows]     INT            DEFAULT ((1)) NOT NULL,
    [SuccessRows]   INT            DEFAULT ((0)) NOT NULL,
    [ErrorRows]     INT            DEFAULT ((0)) NOT NULL,
    [Status]        INT            DEFAULT ((0)) NOT NULL,
    [UpdatedBy]     VARCHAR (50)   NULL,
    [ProcessedTime] DATETIME       NULL,
    CONSTRAINT [PK_BatchExtend_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

