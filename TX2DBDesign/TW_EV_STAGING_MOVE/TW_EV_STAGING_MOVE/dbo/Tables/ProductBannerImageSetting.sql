CREATE TABLE [dbo].[ProductBannerImageSetting] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [ProductId] INT            NOT NULL,
    [HexColor]  VARCHAR (10)   NOT NULL,
    [FontSize]  INT            NOT NULL,
    [PointX]    DECIMAL (6, 2) NOT NULL,
    [PointY]    DECIMAL (6, 2) NOT NULL,
    CONSTRAINT [PK_ProductBannerImageSetting_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_ProductBannerImageSetting_ProductId]
    ON [dbo].[ProductBannerImageSetting]([ProductId] ASC);

