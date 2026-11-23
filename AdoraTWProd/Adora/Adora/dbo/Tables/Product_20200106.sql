CREATE TABLE [dbo].[Product_20200106] (
    [Id]                       INT            IDENTITY (1, 1) NOT NULL,
    [ExternalId]               VARCHAR (50)   NOT NULL,
    [ProgramId]                INT            NULL,
    [Name]                     NVARCHAR (200) NOT NULL,
    [DisplayName]              NVARCHAR (200) NULL,
    [ExternalProductCode]      VARCHAR (50)   NULL,
    [IsSettingBarcode]         BIT            NULL,
    [NotificationMerchantCode] VARCHAR (50)   NULL,
    [FaceValue]                INT            NULL,
    [IsPrepaid]                BIT            NULL,
    [IsMasterProduct]          BIT            NOT NULL,
    [ProductCode]              VARCHAR (50)   NULL
);

