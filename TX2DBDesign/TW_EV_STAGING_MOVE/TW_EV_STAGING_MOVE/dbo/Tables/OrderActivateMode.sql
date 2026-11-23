CREATE TABLE [dbo].[OrderActivateMode] (
    [Id]             INT      IDENTITY (1, 1) NOT NULL,
    [OrderId]        INT      NOT NULL,
    [Mode]           INT      NOT NULL,
    [AfterPublished] INT      NULL,
    [FixDate]        DATETIME NULL,
    CONSTRAINT [PK_OrderActivateMode] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_OrderActivateMode_OrderId]
    ON [dbo].[OrderActivateMode]([OrderId] ASC);

