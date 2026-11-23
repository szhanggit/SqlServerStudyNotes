CREATE TABLE [dbo].[WorkKey] (
    [Id]        INT          IDENTITY (1, 1) NOT NULL,
    [Value]     VARCHAR (48) NOT NULL,
    [CreatedOn] DATETIME     NOT NULL,
    [ExpiredOn] DATETIME     NULL,
    CONSTRAINT [PK_WORKKEY] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

