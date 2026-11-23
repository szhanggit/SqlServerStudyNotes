CREATE TABLE [dbo].[Product] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProgramCode]       VARCHAR (20)   NOT NULL,
    [VendorId]          INT            NOT NULL,
    [ProductCode]       VARCHAR (50)   NOT NULL,
    [VendorProductCode] NVARCHAR (200) NOT NULL,
    [ProductName]       NVARCHAR (200) NULL,
    [CurrencyCode]      NVARCHAR (50)  NULL,
    [Amount]            VARCHAR (50)   NULL,
    [Description]       NVARCHAR (500) NULL,
    [Status]            TINYINT        CONSTRAINT [DF__Product__Status__1ED998B2] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Product_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Product_Vendor_VendorId] FOREIGN KEY ([VendorId]) REFERENCES [dbo].[Vendor] ([Id]),
    CONSTRAINT [UK_Product_ProductCode] UNIQUE NONCLUSTERED ([ProgramCode] ASC, [VendorId] ASC, [ProductCode] ASC)
);

