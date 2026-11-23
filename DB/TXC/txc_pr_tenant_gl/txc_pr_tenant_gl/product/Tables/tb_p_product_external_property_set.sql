CREATE TABLE [product].[tb_p_product_external_property_set] (
    [product_external_property_set_id] INT            IDENTITY (1, 1) NOT NULL,
    [product_external_property_id]     INT            NOT NULL,
    [property_name]                    NVARCHAR (100) NOT NULL,
    [property_value]                   NVARCHAR (500) NOT NULL,
    [description]                      NVARCHAR (500) NOT NULL,
    [timestamp]                        ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_p_product_external_property_set_id] PRIMARY KEY CLUSTERED ([product_external_property_set_id] ASC),
    CONSTRAINT [UK_tb_p_product_external_property_set] UNIQUE NONCLUSTERED ([product_external_property_id] ASC, [property_name] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_product_external_property_id_name]
    ON [product].[tb_p_product_external_property_set]([product_external_property_id] ASC, [property_name] ASC);

