CREATE TABLE [quotation].[tb_qsftt_quotation_service_fee_trigger_time] (
    [id]                          INT             IDENTITY (1, 1) NOT NULL,
    [quotation_id]                INT             NOT NULL,
    [service_fee_trigger_time_id] INT             NOT NULL,
    [sold_price]                  NUMERIC (15, 4) NOT NULL,
    [sold_price_with_tax]         NUMERIC (15, 4) NOT NULL,
    [validity_from]               DATETIME        NOT NULL,
    [validity_end]                DATETIME        NOT NULL,
    [status]                      INT             NOT NULL,
    [created_on]                  DATETIME        NOT NULL,
    [created_by]                  NVARCHAR (50)   NOT NULL,
    [approved_on]                 DATETIME        NULL,
    [approved_by]                 NVARCHAR (50)   NULL,
    CONSTRAINT [PK_tb_qsftt_quotation_service_fee_trigger_time] PRIMARY KEY CLUSTERED ([id] ASC)
);

