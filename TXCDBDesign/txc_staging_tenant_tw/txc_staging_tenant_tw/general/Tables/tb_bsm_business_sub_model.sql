CREATE TABLE [general].[tb_bsm_business_sub_model] (
    [id]                INT IDENTITY (1, 1) NOT NULL,
    [business_model_id] INT NOT NULL,
    [display_name_id]   INT NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

