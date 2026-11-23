CREATE TABLE [product].[tb_p_product_wizard] (
    [product_wizard_id] INT            IDENTITY (1, 1) NOT NULL,
    [wizard_key]        NVARCHAR (40)  NOT NULL,
    [wizard_step]       INT            NOT NULL,
    [content]           NVARCHAR (MAX) NULL,
    [modifier]          NVARCHAR (30)  NOT NULL,
    [create_time]       DATETIME       NOT NULL,
    [update_time]       DATETIME       NULL,
    CONSTRAINT [pk_product_wizard_id] PRIMARY KEY CLUSTERED ([product_wizard_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_product_wizard_wizard_key]
    ON [product].[tb_p_product_wizard]([wizard_key] ASC);

