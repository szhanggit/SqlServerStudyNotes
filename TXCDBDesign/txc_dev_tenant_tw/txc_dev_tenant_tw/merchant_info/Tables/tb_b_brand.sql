CREATE TABLE [merchant_info].[tb_b_brand] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [brand_name] NVARCHAR (100) NOT NULL,
    [media_id]   INT            NOT NULL,
    [status]     TINYINT        NULL,
    [created_on] DATETIME       NOT NULL,
    [created_by] NVARCHAR (50)  NOT NULL,
    [timestamp]  ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_b_brand] PRIMARY KEY CLUSTERED ([id] ASC)
);

