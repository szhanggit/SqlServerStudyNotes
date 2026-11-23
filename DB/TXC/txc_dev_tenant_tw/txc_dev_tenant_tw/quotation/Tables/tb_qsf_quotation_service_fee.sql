CREATE TABLE [quotation].[tb_qsf_quotation_service_fee] (
    [id]             INT             IDENTITY (1, 1) NOT NULL,
    [quotation_id]   INT             NOT NULL,
    [serivce_fee_id] INT             NOT NULL,
    [sold_price]     NUMERIC (15, 4) NOT NULL,
    [quantity]       INT             NOT NULL,
    CONSTRAINT [PK_tb_qsf_quotation_service_fee] PRIMARY KEY CLUSTERED ([id] ASC)
);

