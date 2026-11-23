CREATE TABLE [dbo].[OrderGroup] (
    [Id]               INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderGroupNumber] VARCHAR (50)  NOT NULL,
    [Status]           TINYINT       NOT NULL,
    [CreatedBy]        NVARCHAR (50) NOT NULL,
    [CreatedOn]        DATETIME      NOT NULL,
    [ApprovedBy]       NVARCHAR (50) NULL,
    [ApprovedOn]       DATETIME      NULL,
    CONSTRAINT [PK_OrderGroup_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

