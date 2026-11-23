CREATE TABLE [general].[tb_bm_business_model] (
    [id]                   INT     IDENTITY (1, 1) NOT NULL,
    [is_prepaid]           BIT     NOT NULL,
    [display_name_id]      INT     NOT NULL,
    [finance_formula_type] TINYINT NOT NULL,
    CONSTRAINT [PK_BUSINESSMODEL] PRIMARY KEY CLUSTERED ([id] ASC)
);

