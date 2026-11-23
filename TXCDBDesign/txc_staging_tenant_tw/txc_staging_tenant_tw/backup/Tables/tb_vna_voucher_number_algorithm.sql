CREATE TABLE [backup].[tb_vna_voucher_number_algorithm] (
    [id]              INT           IDENTITY (1, 1) NOT NULL,
    [name_id]         INT           NOT NULL,
    [reflection_type] VARCHAR (100) NOT NULL,
    [description_id]  INT           NULL,
    [support_mode]    TINYINT       NOT NULL
);

