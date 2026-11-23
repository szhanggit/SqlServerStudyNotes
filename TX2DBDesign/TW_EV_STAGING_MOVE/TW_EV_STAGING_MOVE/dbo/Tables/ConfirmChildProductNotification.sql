CREATE TABLE [dbo].[ConfirmChildProductNotification] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [ActionId]        VARCHAR (50)   NOT NULL,
    [RequestBody]     VARCHAR (5000) NOT NULL,
    [ResponseContent] VARCHAR (5000) NULL,
    [CreatedOn]       DATETIME       NOT NULL,
    [UpdatedOn]       DATETIME       NOT NULL,
    [Retry]           INT            NOT NULL,
    [Status]          INT            NOT NULL,
    CONSTRAINT [PK_ConfirmChildProductNotification_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_ConfirmChildProductNotification_Status]
    ON [dbo].[ConfirmChildProductNotification]([Status] ASC);

