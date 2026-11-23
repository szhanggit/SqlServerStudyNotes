CREATE TABLE [product].[tb_p_product_banner_image_setting] (
    [product_banner_image_setting_id] INT            IDENTITY (1, 1) NOT NULL,
    [product_id]                      INT            NOT NULL,
    [hex_color]                       NVARCHAR (10)  NOT NULL,
    [font_size]                       INT            NOT NULL,
    [point_x]                         DECIMAL (6, 2) NOT NULL,
    [point_y]                         DECIMAL (6, 2) NOT NULL,
    [created_by]                      VARCHAR (250)  NULL,
    [created_on]                      DATETIME       NULL,
    [last_updated_by]                 VARCHAR (250)  NULL,
    [last_updated_on]                 DATETIME       NULL,
    CONSTRAINT [PK_product_banner_image_setting_id] PRIMARY KEY CLUSTERED ([product_banner_image_setting_id] ASC)
);

