CREATE TABLE [dbo].[ProductSuperVoucherTemplate] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [ProductVersionId]   INT            NULL,
    [DescriptionContent] NVARCHAR (MAX) NULL,
    [Version]            INT            NOT NULL,
    [VersionTime]        DATETIME       NOT NULL,
    [CreatedBy]          NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_ProductSuperVoucherTemplate_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

