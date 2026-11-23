CREATE TABLE [dbo].[EXT_TW_FamilyMart] (
    [Id]              BIGINT       NOT NULL,
    [Barcode1]        VARCHAR (50) NOT NULL,
    [Barcode2]        VARCHAR (50) NOT NULL,
    [Barcode3]        VARCHAR (50) NOT NULL,
    [Barcode4]        VARCHAR (50) NOT NULL,
    [CreatedOn]       DATETIME     NOT NULL,
    [ImportSessionId] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_EXT_TW_FamilyMart_VoucherId] PRIMARY KEY CLUSTERED ([Id] ASC)
);

