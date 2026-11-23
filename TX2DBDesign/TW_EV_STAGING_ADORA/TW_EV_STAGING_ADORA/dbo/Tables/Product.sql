CREATE TABLE [dbo].[Product] (
    [Id]                       INT            IDENTITY (1, 1) NOT NULL,
    [ExternalId]               VARCHAR (50)   NOT NULL,
    [ProgramId]                INT            NULL,
    [Name]                     NVARCHAR (200) NOT NULL,
    [DisplayName]              NVARCHAR (200) NULL,
    [ExternalProductCode]      VARCHAR (50)   NULL,
    [IsSettingBarcode]         BIT            NULL,
    [FaceValue]                INT            NULL,
    [NotificationMerchantCode] VARCHAR (50)   NULL,
    [IsPrepaid]                BIT            NULL,
    [IsMasterProduct]          BIT            DEFAULT ((0)) NOT NULL,
    [ProductCode]              VARCHAR (50)   NULL,
    CONSTRAINT [PK_Product_Id] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Product_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id]),
    CONSTRAINT [UK_Product_ProgramId_ExternalId] UNIQUE NONCLUSTERED ([ExternalId] ASC, [ProgramId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Product_Status_Id_ProgramId_ExternalId]
    ON [dbo].[Product]([Id] ASC, [ProgramId] ASC, [ExternalId] ASC);

