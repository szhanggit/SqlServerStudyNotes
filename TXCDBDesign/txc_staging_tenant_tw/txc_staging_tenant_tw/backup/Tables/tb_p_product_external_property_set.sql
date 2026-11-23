CREATE TABLE [backup].[tb_p_product_external_property_set] (
    [product_external_property_set_id] INT            IDENTITY (1, 1) NOT NULL,
    [product_external_property_id]     INT            NOT NULL,
    [property_name]                    NVARCHAR (100) NOT NULL,
    [property_value]                   NVARCHAR (500) NOT NULL,
    [description]                      NVARCHAR (500) NOT NULL
);

