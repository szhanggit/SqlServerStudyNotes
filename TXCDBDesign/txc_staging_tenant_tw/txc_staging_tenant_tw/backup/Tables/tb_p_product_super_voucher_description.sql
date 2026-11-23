CREATE TABLE [backup].[tb_p_product_super_voucher_description] (
    [product_super_voucher_description_id] INT            IDENTITY (1, 1) NOT NULL,
    [product_id]                           INT            NOT NULL,
    [description_content]                  NVARCHAR (MAX) NULL,
    [created_by]                           NVARCHAR (50)  NOT NULL,
    [created_on]                           DATETIME       NOT NULL,
    [version]                              INT            NOT NULL
);

