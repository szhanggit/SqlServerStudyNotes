CREATE TABLE [dbo].[TXCProductBannerImageSettingSync] (
    [RunId]        VARCHAR (50)   NOT NULL,
    [TXCProductId] INT            NOT NULL,
    [hex_color]    NVARCHAR (10)  NOT NULL,
    [font_size]    INT            NOT NULL,
    [point_x]      DECIMAL (6, 2) NOT NULL,
    [point_y]      DECIMAL (6, 2) NOT NULL,
    [TX2ProductId] INT            NULL
);

