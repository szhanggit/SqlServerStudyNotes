CREATE TABLE [dbo].[CTBCOrder] (
    [Id]                INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductCode]       VARCHAR (50)   NOT NULL,
    [VoucherNumber]     VARCHAR (50)   NOT NULL,
    [ProductName]       NVARCHAR (200) NOT NULL,
    [ClientOrderNumber] VARCHAR (50)   NOT NULL,
    [SendDate]          INT            NOT NULL,
    [CreatedOn]         DATETIME       NOT NULL,
    CONSTRAINT [PK_CTBCOrder_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

