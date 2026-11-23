CREATE TABLE [dbo].[AdvancedBilling] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [ProductCodePrefix] NVARCHAR (10)  NOT NULL,
    [MerchantName]      NVARCHAR (500) NOT NULL,
    [CreatedBy]         NVARCHAR (50)  NOT NULL,
    [CreatedTime]       DATETIME       NOT NULL,
    [Status]            INT            NOT NULL
);

